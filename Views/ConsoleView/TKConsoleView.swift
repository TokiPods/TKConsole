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
    @IBOutlet weak var titleArrowLabel: UILabel!
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

        setupUI()
        
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
        
        selectedIndexPath = nil
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
    
}
