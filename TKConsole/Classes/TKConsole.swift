//
//  TKConsole.swift
//  TKConsole
//
//  Created by zhengxianda on 05/23/2018.
//  Copyright (c) 2018 zhengxianda. All rights reserved.
//

import Foundation

public class Console {
    
    public static let shared = Console()
    
    /// 当前内存中的日志
    var logList: [TKLog] = [TKLog]()
    /// 当前文档目录中读取出来的符合时间限制的文件信息
    var logFiles: [TKLogFile] = [TKLogFile]()
    
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    
    init() {
        self.updateLogFileList()
    }
}

extension Console {
    
    public static func initGate() {
        if let gateView = TKConsoleGateView.loadFromNib() {
            TKWindow?.addSubview(gateView)
        }
    }
    
}

extension Console {
    
    /// 输出日志
    public static func log(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n",
        _ method: String = #function,
        _ file: String = #file,
        _ line: Int = #line,
        _ column: Int = #column)
    {
        record(items: items,
               separator: separator,
               terminator: terminator,
               type: .log,
               method: method,
               file: file,
               line: line,
               column: column)
    }
    
    /// 输出警告
    public static func warning(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n",
        _ method: String = #function,
        _ file: String = #file,
        _ line: Int = #line,
        _ column: Int = #column)
    {
        record(items: items,
               separator: separator,
               terminator: terminator,
               type: .warning,
               method: method,
               file: file,
               line: line,
               column: column)
    }
    
    /// 输出报错
    public static func error(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n",
        _ method: String = #function,
        _ file: String = #file,
        _ line: Int = #line,
        _ column: Int = #column)
    {
        record(items: items,
               separator: separator,
               terminator: terminator,
               type: .error,
               method: method,
               file: file,
               line: line,
               column: column)
    }
    
    /// 输出报错
    ///
    /// - Parameters:
    ///   - items: 主体内容
    ///   - separator: 主体内容中每个元素的分隔符
    ///   - terminator: 主体内容的结尾符
    ///   - method: 输出来源的方法名
    ///   - file: 输出来源的文件名
    ///   - line: 输出来源的行号
    ///   - column: 输出来源的列号
    static func record(
        items: [Any],
        separator: String,
        terminator: String,
        type: TKLogType,
        method: String,
        file: String,
        line: Int,
        column: Int)
    {
        let log = TKLog(items: items,
                        separator: separator,
                        terminator: terminator,
                        type: type,
                        method: method,
                        file: file,
                        line: line,
                        column: column)
        print(log.message, separator: "", terminator: "")
        Console.shared.logList.append(log)
    }
}

extension Console {
    
    /// 新建日志文件保存当前内存中的日志
    public func saveLog() {
        let fileContent = NSMutableArray(array: logList.map({ (log) -> [String: String] in
            return log.toDictionary()
        }))
        fileContent.write(toFile: TKLogDirPath.appending("\(TKLogFilePrefix)\(Date().timeIntervalSince1970)\(TKLogFileSuffix)"), atomically: true)
        
        logList.removeAll()
        updateLogFileList()
    }
    
    /// 移除限制时间内的所有日志文件
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    public func removeAllLog(form startDate: Date? = nil, to endDate: Date? = nil) {
        checkLimitDate(form: startDate, to: endDate)
        
        logFiles.forEach { (logFile) in
            logFile.removeLog()
        }
        updateLogFileList()
    }
    
    /// 输出限制时间内的所有日志文件
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    public func ptintAllLog(form startDate: Date? = nil, to endDate: Date? = nil,
                            hasDate: Bool = false, hasFrom: Bool = false) {
        checkLimitDate(form: startDate, to: endDate)
        
        logFiles.forEach { (logFile) in
            print("<------|File:\(logFile.name)|------>")
            logFile.printLog(hasDate: hasDate, hasFrom: hasFrom)
        }
    }
    
}

extension Console {
    
    /// 检查输入的限制时间是否更新
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    func checkLimitDate(form startDate: Date? = nil, to endDate: Date? = nil) {
        if startDate != nil && startDate != self.startDate &&
            endDate != nil && endDate != self.endDate {
            self.startDate = startDate ?? self.startDate
            self.endDate = endDate ?? self.endDate
            updateLogFileList()
        }
    }
    
    /// 更新当前日志文件信息为限制时间内的所有日志文件信息
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    func updateLogFileList() {
        self.logFiles = selectLogFileList(form: self.startDate, to: self.endDate)
    }
    
    /// 挑选限制时间内的所有日志文件信息
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    /// - Returns: 数组[日志文件信息]
    func selectLogFileList(form startDate: Date? = nil, to endDate: Date? = nil) -> [TKLogFile] {
        self.startDate = startDate ?? self.startDate
        self.endDate = endDate ?? self.endDate
        
        return fileNameList()
            .map({ (fileName) -> (valid: Bool, logFile: TKLogFile) in
                let logFile = TKLogFile(name: fileName, between: self.startDate, to: self.endDate)
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
    func fileNameList() -> [String] {
        let fileManager = FileManager.default
        let fileNameList = try? fileManager.contentsOfDirectory(atPath: TKLogDirPath)
        return fileNameList ?? []
    }
    
}


