//
//  TKConsoleView.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/1.
//

import Foundation

protocol TKConsoleViewDelegate: class {
    func dismiss(_ consoleView: TKConsoleView)
}

class TKConsoleView: UIView {
    static let nibName = "TKConsoleView"
    
    weak var delegate: TKConsoleViewDelegate?
    
    lazy var blockingView: UIView = {
        let temp = UIView()
        return temp
    }()
    
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
    
    static func loadFromNib() -> TKConsoleView? {
        let gateNib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return gateNib?.first as? TKConsoleView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
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
        let hasDate = Console.shared.hasDate
        let hasFrom = Console.shared.hasFrom
        let filter = Console.shared.filter
        let search = Console.shared.search
        logTextView.attributedText = Console.shared.logList
            .filter({ (log) -> Bool in
                log.filter(hasDate: hasDate, hasFrom: hasFrom, filter: filter ?? "")
            })
            .map({ (log) -> NSAttributedString in
                log.spliceAttributedLog(hasDate: hasDate, hasFrom: hasFrom, search: search ?? "")
            }).join()
        
        if Console.shared.lockBottom {
            let offsetY = max(logTextView.contentSize.height - logTextView.frame.height, 0)
            logTextView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
        }
    }
    
    @IBAction func closeButtonTap(_ sender: Any) {
        self.delegate?.dismiss(self)
    }
    
    @IBAction func saveButtonTap(_ sender: Any) {
        Console.shared.saveLog()
        refreshLog()
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
    
    @IBAction func bottomArrowButtonTap(_ sender: Any) {
        let bottomArrowButton = sender as! UIButton
        bottomArrowButton.isSelected = !bottomArrowButton.isSelected
        
        Console.shared.lockBottom = bottomArrowButton.isSelected
        refreshLog()
    }
    
    @IBAction func topArrowButtonTap(_ sender: Any) {
        logTextView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

extension TKConsoleView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(filterTextField) {
            Console.shared.filter = textField.text
        }
        if textField.isEqual(searchTextField) {
            Console.shared.search = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
