//
//  TKLog.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

public class TKLog {
    
    var type: TKLogType
    
    var message: String
    
    var method: String
    var file: String
    var line: String
    var column: String
    var date: Date = Date()
    var timestamp: String
    
    init(items: Any...,
        separator: String,
        terminator: String,
        
        type: TKLogType = .log,
        
        method: String,
        file: String,
        line: Int,
        column: Int) {
        
        self.message = items.message()
        
        self.type = type
        
        self.method = method
        self.file = file
        self.line = "\(line)"
        self.column = "\(column)"
        self.date = Date()
        self.timestamp = self.date.timestampString()
    }
    
    init(info: [String: String]) {
        self.message = info["message"] ?? ""
        
        self.type = TKLogType(rawValue: info["type"] ?? "log")!
        
        self.method = info["method"] ?? ""
        self.file = info["file"] ?? ""
        self.line = info["line"] ?? ""
        self.column = info["column"] ?? ""
        self.timestamp = info["timestamp"] ?? "0"
        self.date = Date(self.timestamp)
    }
    
    public func toDictionary() -> [String: String]{
        return [
            "message": message,
            
            "type": type.rawValue,
            
            "method": method,
            "file": file,
            "line": line,
            "column": column,
            "timestamp": timestamp
        ]
    }
    
}
