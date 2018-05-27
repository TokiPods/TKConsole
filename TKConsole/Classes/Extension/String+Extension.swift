//
//  String+Extension.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

extension String {
    func isLog() -> Bool {
        return self.hasPrefix(TKLogFilePrefix) && self.hasSuffix(TKLogFileSuffix)
    }
    
    func timeStamp() -> TimeInterval{
        let timeStampString = self.replacingOccurrences(of: TKLogFilePrefix, with: "").replacingOccurrences(of: TKLogFileSuffix, with: "")
        return TimeInterval(timeStampString) ?? 0
    }
}
