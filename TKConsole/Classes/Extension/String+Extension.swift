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

extension String {
    func nsranges(of substring: String) -> [NSRange] {
        return ranges(of: substring).map({ (range) -> NSRange in
            return nsrange(range)
        })
    }
    
    func ranges(of substring: String) -> [Range<String.Index>] {
        var tempString = self
        var ranges = [Range<String.Index>]()
        while var range = tempString.range(of: substring) {
            if let last = ranges.last {
                range = self.index(range.lowerBound, offsetBy: last.upperBound.encodedOffset)..<self.index(range.upperBound, offsetBy: last.upperBound.encodedOffset)
            }
            ranges.append(range)
            tempString = String(self[range.upperBound...])
        }
        return ranges
    }
    
    func nsrange(_ range: Range<String.Index>) -> NSRange{
        guard let from = range.lowerBound.samePosition(in: utf16), let to = range.upperBound.samePosition(in: utf16) else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from), utf16.distance(from: from, to: to))
    }
}
