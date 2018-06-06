//
//  Date+Extension.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

extension Date {
    init(_ timestampString: String) {
        self.init(timeIntervalSince1970: TimeInterval(timestampString) ?? 0)
    }
    
    func timestampString() -> String {
        return String(self.timeIntervalSince1970)
    }
    
    var tk_description: String {
        get {
            return TKDateFormatter().string(from: self)
        }
    }
}
