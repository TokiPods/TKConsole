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

extension Array where Element == NSMutableAttributedString{
    func join() -> NSMutableAttributedString {
        let joinedAttributedString = NSMutableAttributedString(string: "")
        self.forEach { (attributedString) in
            joinedAttributedString.append(attributedString)
        }
        return joinedAttributedString
    }
}
