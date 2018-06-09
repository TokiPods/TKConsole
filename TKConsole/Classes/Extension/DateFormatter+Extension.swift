//
//  DateFormatter+Extension.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/6/9.
//

import Foundation

let TKFullFormat = "YYYY年MM月dd日HH时mm分ss秒SSS"
let TKDateFormat = "YYYY年MM月dd日"
let TKTimeFormat = "HH时mm分ss秒SSS"

extension DateFormatter {
    func string(from date: Date, with dateFormat: String = TKFullFormat) -> String {
        self.dateFormat = dateFormat
        return string(from: date)
    }
}
