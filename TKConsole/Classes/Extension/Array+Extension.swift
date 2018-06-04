//
//  Array+Extension.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

extension Array {
    func message(separator: String = " ", terminator: String = "\n") -> String {
        var message = ""
        self.forEach { (sureItems) in
            let tempItems = sureItems as! [Any]
            tempItems.forEach({ (item) in
                if message.count > 0 {
                    message += "\(separator)"
                }
                message += "\(item)"
            })
        }
        message += "\(terminator)"
        
        return message
    }
}

extension Array where Element == TKLog{
    func message(hasDate: Bool = false, hasFrom: Bool = false) -> String {
        var message = ""
        self.forEach { (log) in
            message += log.message(hasDate: hasDate, hasFrom: hasFrom)
        }
        return message
    }
    
    func attributedMessage(hasDate: Bool = false, hasFrom: Bool = false) -> NSAttributedString {
        let attributedMessage = NSMutableAttributedString(string: "")
        self.forEach { (log) in
            attributedMessage.append(log.attributedMessage(hasDate: hasDate, hasFrom: hasFrom))
        }
        return attributedMessage.copy() as! NSAttributedString
    }
}
