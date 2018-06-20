//
//  TKFileListTableViewHeader.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/9.
//

import Foundation

class TKFileListTableViewHeader: UIView {
    static let nibName = "TKFileListTableViewHeader"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    static func loadFromNib() -> TKFileListTableViewHeader? {
        let nib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return nib?.first as? TKFileListTableViewHeader
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(title: String) {
        titleLabel.text = "📁: Dir_" + title
    }

}
