//
//  TKConsoleView+TableView.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

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
