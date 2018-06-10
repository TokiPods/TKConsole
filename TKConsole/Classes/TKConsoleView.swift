//
//  TKConsoleView.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/1.
//

import Foundation

public protocol TKConsoleViewDelegate: class {
    func dismiss(_ consoleView: TKConsoleView)
}

open class TKConsoleView: UIView {
    static let nibName = "TKConsoleView"
    
    enum Status {
        case current
        case history
    }
    
    var status: Status = .current
    
    weak var delegate: TKConsoleViewDelegate?
    
    var fileMapList: [TKLogFileMap] = [TKLogFileMap]()
    var selectedIndexPath: IndexPath?
    var startDatePickerValue: Date = Date.distantPast
    var endDatePickerValue: Date = Date.distantFuture
    
    lazy var blockingView: UIView = {
        let temp = UIView()
        return temp
    }()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    
    @IBOutlet weak var fileListView: UIView!
    @IBOutlet weak var fileListViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fileListTableView: UITableView!
    
    @IBOutlet weak var fileListDatePickView: UIView!
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var startDateConfirmButton: UIButton!
    @IBOutlet weak var endDateConfirmButton: UIButton!
    @IBOutlet weak var fileListDatePickViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var bottomArrowButton: UIButton!
    
    @IBOutlet weak var logTextView: UITextView!
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    open static func loadFromNib() -> TKConsoleView? {
        let nib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return nib?.first as? TKConsoleView
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor

        fileListDatePickView.layer.borderWidth = 0.5
        fileListDatePickView.layer.borderColor = UIColor.lightGray.cgColor
        startDateConfirmButton.layer.borderWidth = 1
        startDateConfirmButton.layer.borderColor = UIColor.white.cgColor
        endDateConfirmButton.layer.borderWidth = 1
        endDateConfirmButton.layer.borderColor = UIColor.white.cgColor
        startDateButton.setTitle(Console.shared.minDate.dateDescription, for: UIControlState.normal)
        endDateButton.setTitle(Console.shared.maxDate.dateDescription, for: UIControlState.normal)
        
        searchView.layer.borderWidth = 0.5
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchView.layer.shadowColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOpacity = 0.2
        searchView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: searchView.bounds.height/2, width: searchView.bounds.width, height: searchView.bounds.height/2)).cgPath
        
        searchTextField.text = Console.shared.search
        
        bottomArrowButton.isSelected = Console.shared.lockBottom
        
        filterView.layer.borderWidth = 0.5
        filterView.layer.borderColor = UIColor.lightGray.cgColor
        filterView.layer.shadowOffset = CGSize(width: 0, height: -2)
        filterView.layer.shadowColor = UIColor.lightGray.cgColor
        filterView.layer.shadowOpacity = 0.2
        filterView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: filterView.bounds.width, height: filterView.bounds.height/2)).cgPath
        
        filterTextField.text = Console.shared.filter
        
        dateButton.isSelected = Console.shared.hasDate
        fromButton.isSelected = Console.shared.hasFrom
        
        startDatePicker.backgroundColor = UIColor.lightGray
        endDatePicker.backgroundColor = UIColor.lightGray
        startDatePickerValue = Console.shared.startDate
        endDatePickerValue = Console.shared.endDate
        
        refreshLog()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLog), name: NSNotification.Name.init(rawValue: Console.recordNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFilterViewConstraint(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFilterViewConstraint(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshFilterViewConstraint(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = userInfo[NotificationCenter.UIKeyboardFrameEndUserInfoKey] as? CGRect{
                let riseHeight = UIScreen.main.bounds.height - keyboardFrame.minY
                let bottomMargin = UIScreen.main.bounds.height - Console.shared.consoleOrigin.y - Console.shared.consoleSize.height
                if riseHeight == 0 { //收起
                    filterViewBottomConstraint.constant = riseHeight + bottomMargin
                    filterViewTopConstraint.constant = bottomMargin + riseHeight - filterViewBottomConstraint.constant
                }else{ //弹出
                    filterViewTopConstraint.constant = bottomMargin - riseHeight + filterViewBottomConstraint.constant
                    filterViewBottomConstraint.constant = riseHeight - bottomMargin
                }
            }
        }
    }
    
    @objc func refreshLog() {
        switch status {
        case .current:
            refresh(logList: Console.shared.logList)
        case .history:
            if let indexPath = selectedIndexPath {
                let file = fileMapList[indexPath.section].fileList[indexPath.row]
                refresh(logList: file.content)
            }
        }
    }
    
    func refreshLogFileList() {
        fileMapList = Console.shared.currentLogFileList
            .reduce([String: [TKLogFile]](), { (map, logFile) -> [String: [TKLogFile]] in
                var tempMap = map
                var tempFileList = tempMap[logFile.dateString] ?? [TKLogFile]()
                tempFileList.append(logFile)
                tempMap[logFile.dateString] = tempFileList
                return tempMap
            })
            .map({ (logFileMapData) -> TKLogFileMap in
                return TKLogFileMap(dateString: logFileMapData.key, fileList: logFileMapData.value)
            })
            .sorted(by: { (first, second) -> Bool in
                return first.date < second.date
            })
        fileListTableView.reloadData()
    }
    
    func refresh(logList: [TKLog]) {
        
        let hasDate = Console.shared.hasDate
        let hasFrom = Console.shared.hasFrom
        let filter = Console.shared.filter
        let search = Console.shared.search
        
        let attributedLog = logList
            .filter({ (log) -> Bool in
                log.filter(hasDate: hasDate, hasFrom: hasFrom, filter: filter ?? "")
            })
            .map({ (log) -> NSMutableAttributedString in
                log.spliceAttributedLog(hasDate: hasDate, hasFrom: hasFrom, search: search ?? "")
            }).join()
        attributedLog.append(NSAttributedString(string: "..."))
        
        logTextView.attributedText = attributedLog
        
        if Console.shared.lockBottom {
            let offsetY = max(logTextView.contentSize.height - logTextView.frame.height, 0)
            logTextView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
        
    }
    
    @IBAction func titleButtonTap(_ sender: Any) {
        fileListView.isHidden = !fileListView.isHidden
        
        if fileListView.isHidden {
            fileListViewHeightConstraint.constant = 0
            fileListDatePickViewHeightConstraint.constant = 0
        }else{
            fileListViewHeightConstraint.constant = 160
            fileListDatePickViewHeightConstraint.constant = 25

            refreshLogFileList()
        }
    }
    
    @IBAction func closeButtonTap(_ sender: Any) {
        self.delegate?.dismiss(self)
    }
    
    @IBAction func optionButtonTap(_ sender: Any) {
        switch status {
        case .current:
            Console.shared.saveLog()
            
            refreshLogFileList()
            fileListTableView.setContentOffset(CGPoint(x: 0, y: fileListTableView.contentSize.height-fileListTableView.frame.height), animated: true)
        case .history:
            status = .current
            
            titleLabel.text = "Current Log"
            optionButton.setTitle("Save", for: UIControlState.normal)
            
            if let indexPath = selectedIndexPath {
                fileListTableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        refreshLog()
    }
    
    @IBAction func refreshButtonTap(_ sender: Any) {
        Console.shared.updateLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        UIAlertView(title: "",
                    message: "确认删除该日志文件",
                    delegate: self,
                    cancelButtonTitle: "取消",
                    otherButtonTitles: "确认")
            .show()
    }
    
    @IBAction func startDateButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        endDatePicker.isHidden = true
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDateButton.setTitle(endDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.endDate = endDatePickerValue
        
        //开启开始时间的选择器
        startDatePicker.isHidden = false
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDatePicker.setDate(Console.shared.startDate, animated: false)
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func endDateButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        startDatePicker.isHidden = true
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDateButton.setTitle(startDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.startDate = startDatePickerValue
        
        //开启开始时间的选择器
        endDatePicker.isHidden = false
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDatePicker.setDate(Console.shared.endDate, animated: false)
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func startDateConfirmButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        startDatePicker.isHidden = true
        startDateConfirmButton.isHidden = startDatePicker.isHidden
        startDateButton.setTitle(startDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.startDate = startDatePickerValue
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func endDateConfirmButtonTap(_ sender: Any) {
        //关闭结束时间的选择器
        endDatePicker.isHidden = true
        endDateConfirmButton.isHidden = endDatePicker.isHidden
        endDateButton.setTitle(endDatePickerValue.dateDescription, for: UIControlState.normal)
        Console.shared.endDate = endDatePickerValue
        
        Console.shared.updateCurrentLogFileList()
        refreshLogFileList()
        fileListTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func bottomArrowButtonTap(_ sender: Any) {
        let bottomArrowButton = sender as! UIButton
        bottomArrowButton.isSelected = !bottomArrowButton.isSelected
        
        Console.shared.lockBottom = bottomArrowButton.isSelected
        refreshLog()
    }
    
    @IBAction func topArrowButtonTap(_ sender: Any) {
        logTextView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    @IBAction func dateButtonTap(_ sender: Any) {
        let dateButton = sender as! UIButton
        dateButton.isSelected = !dateButton.isSelected
        
        Console.shared.hasDate = dateButton.isSelected
        refreshLog()
    }
    
    @IBAction func fromButtonTap(_ sender: Any) {
        let fromButton = sender as! UIButton
        fromButton.isSelected = !fromButton.isSelected
        
        Console.shared.hasFrom = fromButton.isSelected
        refreshLog()
    }
    
    @IBAction func startDatePickerValueChange(_ sender: Any) {
        startDatePickerValue = startDatePicker.date
    }
    
    @IBAction func endDatePickerValueChange(_ sender: Any) {
        endDatePickerValue = endDatePicker.date
    }
    
}

extension TKConsoleView: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(filterTextField) {
            Console.shared.filter = textField.text
        }
        if textField.isEqual(searchTextField) {
            Console.shared.search = textField.text
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TKConsoleView: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return fileMapList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileMapList[section].fileList.count
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 18
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 18
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = TKFileListTableViewHeader.loadFromNib() {
            header.update(title: fileMapList[section].dateString)
            return header
        }else{
            return UIView()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TKFileListTableViewCell.identify) as? TKFileListTableViewCell ?? TKFileListTableViewCell.loadFromNib() {
            cell.update(logFile: fileMapList[indexPath.section].fileList[indexPath.row])
            return cell
        }else{
            return UITableViewCell()
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        status = .history
        selectedIndexPath = indexPath
        
        let file = fileMapList[indexPath.section].fileList[indexPath.row]
        titleLabel.text = file.dateString+file.timeString
        optionButton.setTitle("Current", for: UIControlState.normal)
        
        refreshLog()
    }
}

extension TKConsoleView: UIAlertViewDelegate {
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            if let indexPath = selectedIndexPath {
                let file = fileMapList[indexPath.section].fileList[indexPath.row]
                file.removeLog()
                
                Console.shared.updateLogFileList()
                refreshLogFileList()
            }
        }
    }
}
