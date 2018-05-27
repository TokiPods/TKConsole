//
//  TimerInterval+Extension.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

extension TimeInterval {
    func isBetween(form startDate: Date, to endDate: Date) -> Bool {
        return self > startDate.timeIntervalSince1970 && self < endDate.timeIntervalSince1970
    }
}
