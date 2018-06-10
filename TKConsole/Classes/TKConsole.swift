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
    
    static let recordNotificationName = "TKRecordNotificationName"
    static let animateDuration = 0.3
    
    /// 当前内存中的日志
    var logList: [TKLog] = [TKLog]()
    /// 当前文档目录中读取出来的符合时间限制的文件信息
    var currentLogFileList: [TKLogFile] = [TKLogFile]()
    var fullLogFileList: [TKLogFile] = [TKLogFile]()
    
    var maxDate: Date = Date.distantPast
    var minDate: Date = Date.distantFuture
    
    var startDate: Date = Date.distantPast
    var endDate: Date = Date.distantFuture
    
    var search: String?
    var lockBottom: Bool = true
    var filter: String?
    var hasDate: Bool = false
    var hasFrom: Bool = false
    
    lazy var blockingView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return temp
    }()
    
    var consoleGateView: TKConsoleGateView?
    var consoleView: TKConsoleView?
    
    var consoleGateCenter: CGPoint = CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100)
    var consoleGateSize: CGSize = CGSize(width: 40, height: 40)
    var consoleOrigin: CGPoint = CGPoint(x: 20, y: 20)
    var consoleSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40)
    
    init() {
        self.updateLogFileList()
    }
}

extension Console {
    
    public static func addConsoleGateView(frame: CGRect? = nil) {
        guard Console.shared.consoleGateView == nil else { return }
        
        if let window = TKWindow, let consoleGateView = TKConsoleGateView.loadFromNib() {
            let consoleGateCenter = frame != nil ? CGPoint(x: frame!.minX, y: frame!.midY) : Console.shared.consoleGateCenter
            let consoleGateSize = frame != nil ? frame!.size : Console.shared.consoleGateSize
            
            consoleGateView.delegate = Console.shared
            consoleGateView.frame = CGRect(origin: CGPoint(x: consoleGateCenter.x - consoleGateSize.width/2,
                                                           y: consoleGateCenter.y - consoleGateSize.height/2),
                                           size: consoleGateSize)
            Console.shared.consoleGateView = consoleGateView
            window.addSubview(consoleGateView)
        }
    }
    
    public static func removeConsoleGateView() {
        if let consoleGateView = Console.shared.consoleGateView {
            consoleGateView.removeFromSuperview()
            Console.shared.consoleGateView = nil
        }
    }
    
    static func showConsoleGateView(center: CGPoint? = nil, size: CGSize? = nil) {
        Console.shared.consoleGateCenter = center ?? Console.shared.consoleGateCenter
        Console.shared.consoleGateSize = size ?? Console.shared.consoleGateSize
        
        if let window = TKWindow, let consoleGateView = Console.shared.consoleGateView ?? TKConsoleGateView.loadFromNib() {
            Console.shared.consoleGateView = consoleGateView
            consoleGateView.delegate = Console.shared
            
            let consoleGateCenter = Console.shared.consoleGateCenter
            let consoleGateSize = Console.shared.consoleGateSize
            let blockingView = Console.shared.blockingView
            
            blockingView.frame = window.frame
            consoleGateView.frame = CGRect(origin: consoleGateCenter, size: CGSize.zero)
            
            window.addSubview(blockingView)
            window.addSubview(consoleGateView)
            
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           options: UIViewAnimationOptions.layoutSubviews,
                           animations: {
                            consoleGateView.frame = CGRect(origin: CGPoint(x: consoleGateCenter.x - consoleGateSize.width / 2, y: consoleGateCenter.y - consoleGateSize.height / 2), size: consoleGateSize)
            }) { (completion) in
                if completion {
                    blockingView.removeFromSuperview()
                }
            }
        }
    }
    
    static func closeConsoleGateView(center: CGPoint? = nil) {
        Console.shared.consoleGateCenter = center ?? Console.shared.consoleGateCenter
        
        if let window = TKWindow, let consoleGateView = Console.shared.consoleGateView {
            let consoleGateCenter = Console.shared.consoleGateCenter
            let blockingView = Console.shared.blockingView
            
            blockingView.frame = window.frame
            
            window.addSubview(blockingView)
            window.addSubview(consoleGateView)
            
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           options: UIViewAnimationOptions.layoutSubviews,
                           animations: {
                            consoleGateView.frame = CGRect(origin: consoleGateCenter, size: CGSize.zero)
            }) { (completion) in
                if completion {
                    Console.shared.consoleGateView = nil
                    consoleGateView.removeFromSuperview()
                    blockingView.removeFromSuperview()
                    showConsoleView(center: center, size: Console.shared.consoleSize)
                }
            }
        }
    }
    
    static func showConsoleView(center: CGPoint? = nil, size: CGSize? = nil) {
        Console.shared.consoleGateCenter = center ?? Console.shared.consoleGateCenter
        Console.shared.consoleSize = size ?? Console.shared.consoleSize
        
        if let window = TKWindow, let consoleView = Console.shared.consoleView ?? TKConsoleView.loadFromNib() {
            Console.shared.consoleView = consoleView
            consoleView.delegate = Console.shared
            
            let consoleGateCenter = Console.shared.consoleGateCenter
            let consoleOrigin = Console.shared.consoleOrigin
            let consoleSize = Console.shared.consoleSize
            let blockingView = Console.shared.blockingView
            
            blockingView.frame = window.frame
            consoleView.frame = CGRect(origin: consoleGateCenter, size: CGSize.zero)
            
            window.addSubview(blockingView)
            window.addSubview(consoleView)
            
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           options: UIViewAnimationOptions.layoutSubviews,
                           animations: {
                            consoleView.frame = CGRect(origin: consoleOrigin, size: consoleSize)
            }) { _ in
                
            }
        }
    }
    
    static func closeConsoleView(center: CGPoint? = nil) {
        Console.shared.consoleGateCenter = center ?? Console.shared.consoleGateCenter
        
        if let window = TKWindow, let consoleView = Console.shared.consoleView {
            let consoleGateCenter = Console.shared.consoleGateCenter
            let blockingView = Console.shared.blockingView
            
            blockingView.frame = window.frame
            
            window.addSubview(blockingView)
            window.addSubview(consoleView)
            
            UIView.animate(withDuration: animateDuration,
                           delay: 0,
                           options: UIViewAnimationOptions.layoutSubviews,
                           animations: {
                            consoleView.frame = CGRect(origin: consoleGateCenter, size: CGSize.zero)
            }) { (completion) in
                if completion {
                    Console.shared.consoleView = nil
                    consoleView.removeFromSuperview()
                    blockingView.removeFromSuperview()
                    showConsoleGateView(center: center, size: Console.shared.consoleGateSize)
                }
            }
        }
    }
    
}

extension Console: TKConsoleGateViewDelegate, TKConsoleViewDelegate {
    
    public func dismiss(_ consoleGateView: TKConsoleGateView) {
        Console.closeConsoleGateView(center: consoleGateView.center)
    }
    
    public func dismiss(_ consoleView: TKConsoleView) {
        Console.closeConsoleView()
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
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: Console.recordNotificationName), object: log)
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
        
        currentLogFileList.forEach { (logFile) in
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
        
        currentLogFileList.forEach { (logFile) in
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
    
    /// 更新所有日志文件信息 同时 更新当前日志文件信息为限制时间内的所有日志文件信息
    func updateLogFileList() {
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
    
    func updateCurrentLogFileList() {
        currentLogFileList = fullLogFileList.filter { (logFile) -> Bool in
            return logFile.date >= startDate.weeDate && logFile.date <= endDate.hugeDate
        }
    }
    
    /// 挑选限制时间内的所有日志文件信息
    ///
    /// - Parameters:
    ///   - startDate: 起始时间
    ///   - endDate: 结束时间
    /// - Returns: 数组[日志文件信息]
    func selectLogFileList(form startDate: Date = Date.distantPast, to endDate: Date = Date.distantFuture) -> [TKLogFile] {
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
    func fileNameList() -> [String] {
        let fileManager = FileManager.default
        let fileNameList = try? fileManager.contentsOfDirectory(atPath: TKLogDirPath)
        return fileNameList ?? []
    }
    
}


