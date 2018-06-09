//
//  TKFileListTableViewCell.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/8.
//

import Foundation

class TKFileListTableViewCell: UITableViewCell {
    static let nibName = "TKFileListTableViewCell"
    static let identify = "TKFileListTableViewCellId"
    
    @IBOutlet weak var tagView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static func loadFromNib() -> TKFileListTableViewCell? {
        let nib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return nib?.first as? TKFileListTableViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(logFile: TKLogFile) {
        titleLabel.text = "📃: Log_" + logFile.timeString
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        tagView.isHidden = !selected
    }
}
