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
    
    /// 是否执行打印
    var shouldPrint = false
    /// 内存中日志条数最大值
    var maxLogCount = 200
    /// App终止运行时 true: 保存, false: 清空日志
    var autoSaveOnTerminate = false
    /// 超出内存中日志条数最大值时 true: 保存, false: 清空日志
    var autoSaveOnOverflow = false
    /// 当前内存中的日志
    var logList: [TKLog] = [TKLog]()
    /// 当前文档目录中读取出来的符合时间限制的文件信息
    var currentLogFileList: [TKLogFile] = [TKLogFile]()
    /// 当前文档目录中读取出来的全部文件信息
    var fullLogFileList: [TKLogFile] = [TKLogFile]()
    
    /// 沙盒内全部日志中最大日期
    var maxDate: Date = Date.distantFuture
    /// 沙盒内全部日志中最小日期
    var minDate: Date = Date.distantPast
    
    /// 筛选器起始日期
    var startDate: Date = Date.distantPast
    /// 筛选器结束日期
    var endDate: Date = Date.distantFuture
    
    /// 查找(高亮)的字符串
    var search: String?
    /// 是否锁定显示最新(最下方)的日志
    var lockBottom: Bool = true
    /// 筛选的字符串
    var filter: String?
    /// 是否显示日期
    var hasDate: Bool = false
    /// 是否显示出处
    var hasFrom: Bool = false
    
    /// 遮盖
    lazy var blockingView: UIView = {
        let temp = UIView()
        temp.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return temp
    }()
    
    /// 日志入口
    var consoleGateView: TKConsoleGateView?
    /// 日志显示
    var consoleView: TKConsoleView?
    
    /// 日志所在的窗口
    var keyWindow: UIWindow?
    /// 日志入口的中心点定位
    var consoleGateCenter: CGPoint = CGPoint(x: UIScreen.main.bounds.maxX - 100, y: UIScreen.main.bounds.maxY - 100)
    /// 日志入口的尺寸
    var consoleGateSize: CGSize = CGSize(width: 40, height: 40)
    /// 日志的原点定位
    var consoleOrigin: CGPoint = CGPoint(x: 20, y: 20)
    /// 日志的尺寸
    var consoleSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height - 40)

    init() {
        self.updateLogFileList()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(autoSaveOnApplicationWillTerminate),
                                               name: NSNotification.Name.UIApplicationWillTerminate,
                                               object: nil)
    }
}

extension Console {
    @objc func autoSaveOnApplicationWillTerminate() {
        if autoSaveOnTerminate {
            saveLog()
        }
    }
}
