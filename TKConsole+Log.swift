//
//  TKConsole+Log.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension Console {
    /// 新建日志文件保存当前内存中的日志
    public func saveLog() {
        let fileContent = NSMutableArray(array: logList.map({ (log) -> [String: String] in
            return log.toDictionary()
        }))
        fileContent.write(toFile: TKLogDirPath.appending("\(TKLogFilePrefix)\(Date().timeIntervalSince1970)\(TKLogFileSuffix)"), atomically: true)
        
        clearLog()
        updateLogFileList()
    }
    
    /// 清空当前内存中的日志
    public func clearLog() {
        logList.removeAll()
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
    
    /// 输出日志
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
        // 判断是否需要打印
        if Console.shared.shouldPrint {
            print(log.message, separator: "", terminator: "")
        }
        
        // 添加新的日志内容
        Console.shared.logList.append(log)
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: Console.recordNotificationName), object: log)
        
        // 判断当前日志条数是否超出限制
        if Console.shared.logList.count > Console.shared.maxLogCount {
            if Console.shared.autoSaveOnOverflow {
                Console.shared.saveLog()
            }else{
                Console.shared.clearLog()
            }
        }
    }
}
