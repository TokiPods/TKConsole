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
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var filterView: UIView!
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var fromButton: UIButton!
    
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
        
        filterView.layer.borderWidth = 0.5
        filterView.layer.borderColor = UIColor.lightGray.cgColor
        
        dateButton.isSelected = Console.shared.hasDate
        fromButton.isSelected = Console.shared.hasFrom
        
        refreshLog()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshLog), name: NSNotification.Name.init(rawValue: Console.recordNotificationName), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshLog() {
        logTextView.attributedText = Console.shared.logList.attributedMessage(hasDate: Console.shared.hasDate,
                                                                              hasFrom: Console.shared.hasFrom)
        
        let offsetY = max(logTextView.contentSize.height - logTextView.frame.height, 0)
        logTextView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
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
    
}
