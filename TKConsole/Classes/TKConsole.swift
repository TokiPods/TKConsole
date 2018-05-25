//
//  TKConsole.swift
//  TKConsole
//
//  Created by zhengxianda on 05/23/2018.
//  Copyright (c) 2018 zhengxianda. All rights reserved.
//

import Foundation

public class Console {
    
    static let shared = Console()
    
    public static func log(
        _ items: Any...,
        separator: String = " ",
        terminator: String = "\n",
        _ file: String = #file,
        _ method: String = #function,
        _ line: Int = #line,
        _ column: Int = #column)
    {
        var itemsString = ""
        items.forEach { (item) in
            itemsString += "\(items)"
        }
        
        let log = "\(Date()):\(itemsString)=from=\((file as NSString).lastPathComponent):\(method):[\(line),\(column)]"
        Console.shared.logList.add(log)
        
        print(log)
    }
    
    var logDirPath: String = {
        NSHomeDirectory().appending("/Documents/")
    }()
    
    var logPath: String {
        get {
            return logDirPath.appending("TKConsole_Log_\(Date().timeIntervalSince1970).plist")
        }
    }
    
    var logList: NSMutableArray = NSMutableArray()
    
    public static func saveLog() {
        let logList = Console.shared.logList
        logList.add("\(Date()):save-------------------")
        logList.write(toFile: Console.shared.logPath, atomically: true)
        Console.shared.logList = NSMutableArray()
    }
    
    public static func readLog(form startDate: Date, to endDate: Date) {
        let logPathList = selectLogPathList(form: startDate, to: endDate)
        logPathList.forEach { (logPath) in
            let logs = NSMutableArray(contentsOfFile: Console.shared.logDirPath.appending(logPath))
            print("\(Date()):File📁:\(logPath)")
            logs?.forEach({ (log) in
                print(log)
            })
        }
    }
    
    public static func selectLogPathList(form startDate: Date, to endDate: Date) -> [String] {
        let fileManager = FileManager.default
        let logPathList = try? fileManager.contentsOfDirectory(atPath: Console.shared.logDirPath)
        let filteredLogPathList = logPathList?.filter({ (logPath) -> Bool in
            if logPath.hasPrefix("TKConsole_Log_") && logPath.hasSuffix(".plist") {
                let timestampString = logPath.replacingOccurrences(of: "TKConsole_Log_", with: "").replacingOccurrences(of: ".plist", with: "")
                let timestamp = Double(timestampString) ?? 0
                return timestamp > startDate.timeIntervalSince1970 && timestamp < endDate.timeIntervalSince1970
            }else{
                return false
            }
            
        })
        return filteredLogPathList ?? []
    }
    
}
