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
    
    static func loadFromNib() -> TKConsoleView? {
        let gateNib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return gateNib?.first as? TKConsoleView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func closeButtonTap(_ sender: Any) {
        self.delegate?.dismiss(self)
    }
}
