//
//  TKLogFile.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

public class TKLogFile {
    
    var valid: Bool = false
    
    var name: String
    
    var timestamp: TimeInterval = 0
    
    var path: String = "Path_error!"
    var date: Date = Date.distantPast
    var dateString: String = "Date_error!"
    var timeString: String = "Time_error!"
    var logInfoList: [[String: String]] = [[String: String]]()
    var content: [TKLog] = []
    
    init(name: String, between startDate: Date = Date.distantPast, to endDate: Date = Date.distantFuture) {
        self.name = name
        //判断是否为日志文件
        if !self.name.isLog() {
            return
        }
        
        self.timestamp = self.name.timeStamp()
        //判断是否为限制时间内的日志
        if !self.timestamp.isBetween(form: startDate, to: endDate){
            return
        }
        
        self.path = TKLogDirPath.appending(self.name)
        self.date = Date(timeIntervalSince1970: self.timestamp)
        self.dateString = self.date.dateDescription
        self.timeString = self.date.timeDescription
        self.logInfoList = NSMutableArray(contentsOfFile: self.path) as? [[String: String]] ?? [[String: String]]()
        self.content = self.logInfoList.map({ (logInfo) -> TKLog in
            return TKLog(info: logInfo)
        })
        
        self.valid = true
    }
    
}

public extension TKLogFile {
    public func printLog(hasDate: Bool = false, hasFrom: Bool = false) {
        content.forEach { (log) in
            print(log.messageLog, separator: "", terminator: "")
        }
    }
    
    public func removeLog() {
        do {
            try FileManager.default.removeItem(atPath: path)
        }catch {
            print("Remove_field:\(path)")
        }
    }
}
