//
//  TKLogFileMap.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/6/9.
//

import Foundation

class TKLogFileMap {
    
    var dateString: String
    var fileList: [TKLogFile]
    
    var date: Date
    
    init(dateString: String, fileList: [TKLogFile] = [TKLogFile]()) {
        self.dateString = dateString
        self.fileList = fileList
        
        self.date = DateFormatter().date(from: self.dateString, with: TKDateFormat) ?? Date()
    }
    
}
