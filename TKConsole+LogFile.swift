//
//  TKConsole+LogFile.swift
//  TKConsole
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension Console {
    /// 更新所有日志文件信息 同时 更新当前日志文件信息为限制时间内的所有日志文件信息
    public func updateLogFileList() {
        fullLogFileList = selectLogFileList(form: Date.distantPast, to: Date.distantFuture)
        minDate = fullLogFileList.first?.date ?? minDate
        maxDate = fullLogFileList.last?.date ?? maxDate
        
        if startDate < minDate {
            startDate = minDate
        }
        if endDate > maxDate {
            endDate = maxDate
        }
        
        updateCurrentLogFileList()
    }
    
    public func updateCurrentLogFileList() {
        currentLogFileList = fullLogFileList.select(form: startDate, to: endDate)
    }
}

extension Console {
    
    /// 移除限制时间内的所有日志文件
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    public func removeAllLog(form startDate: Date = Date.distantPast, to endDate: Date = Date.distantFuture) {
        let logFileList = fullLogFileList.select(form: startDate, to: endDate)
        
        logFileList.forEach { (logFile) in
            logFile.removeLog()
        }
        updateLogFileList()
    }
    
    /// 输出限制时间内的所有日志文件
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    public func ptintAllLog(form startDate: Date = Date.distantPast, to endDate: Date = Date.distantFuture,
                            hasDate: Bool = false, hasFrom: Bool = false) {
        let logFileList = fullLogFileList.select(form: startDate, to: endDate)
        
        logFileList.forEach { (logFile) in
            print("<------|File:\(logFile.name)|------>")
            logFile.printLog(hasDate: hasDate, hasFrom: hasFrom)
        }
    }

    /// 挑选限制时间内的所有日志文件信息
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    /// - Returns: 数组[日志文件信息]
    public func selectLogFileList() -> [TKLogFile] {
        return fileNameList()
            .map({ (fileName) -> (valid: Bool, logFile: TKLogFile) in
                let logFile = TKLogFile(name: fileName, between: startDate, to: endDate)
                return (valid: logFile.valid, logFile: logFile)
            })
            .filter({ (valid, logFile) -> Bool in
                return valid
            })
            .map({ (_, logFile) -> TKLogFile in
                return logFile
            })
            .sorted(by: { (first, second) -> Bool in
                return first.timestamp < second.timestamp
            })
    }
    
    /// 获取当前文档目录所有文件路径
    ///
    /// - Returns: 文件路径(数组)
    public func fileNameList() -> [String] {
        let fileManager = FileManager.default
        let fileNameList = try? fileManager.contentsOfDirectory(atPath: TKLogDirPath)
        return fileNameList ?? []
    }
}
