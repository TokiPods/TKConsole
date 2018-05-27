//
//  TKDateFormatter.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

let TKDateFormat = "YYYY年MM月dd日HH时mm分ss秒"

class TKDateFormatter: DateFormatter {
    public override init() {
        super.init()
        self.dateFormat = TKDateFormat
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
