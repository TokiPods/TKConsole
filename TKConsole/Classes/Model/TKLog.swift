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
    
    var dateLog: String = ""
    var messageLog: String = ""
    var fromLog: String = ""
    var dateAttributedLog: NSAttributedString = NSAttributedString(string: "")
    var messageAttributedLog: NSAttributedString = NSAttributedString(string: "")
    var fromAttributedLog: NSAttributedString = NSAttributedString(string: "")
    
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
        
        parseLogs()
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
        
        parseLogs()
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

    func parseLogs() {
        dateLog = date.tk_description + ": \n"
        messageLog = message
        fromLog = "<" + "method:\(method)_in:\((file as NSString).lastPathComponent)[\(line),\(column)]" + ">" + "\n"
        
        dateAttributedLog = NSAttributedString(string: dateLog, attributes: [NSAttributedStringKey.backgroundColor : UIColor.gray,
                                                                             NSAttributedStringKey.foregroundColor: UIColor.white])
        messageAttributedLog = NSAttributedString(string: messageLog)
        fromAttributedLog = NSAttributedString(string: fromLog, attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
    }
    
    func filter(hasDate: Bool = false, hasFrom: Bool = false, filter: String = "") -> Bool {
        guard filter != "" else { return true }
        
        let spliceLog = self.spliceLog(hasDate: hasDate, hasFrom: hasFrom)
        let result = spliceLog.contains(filter)
        return result
    }
    
    func spliceLog(hasDate: Bool = false, hasFrom: Bool = false) -> String {
        let log = "\(hasDate ? dateLog : "")\(messageLog)\(hasFrom ? fromLog : "")"
        return log
    }
    
    func spliceAttributedLog(hasDate: Bool = false, hasFrom: Bool = false, search: String = "") -> NSAttributedString {
        let log = NSMutableAttributedString(string: "")
        if hasDate {
            log.append(dateAttributedLog)
        }
        log.append(messageAttributedLog)
        if hasFrom {
            log.append(fromAttributedLog)
        }
        
        if search != "" {
            let spliceLog = self.spliceLog(hasDate: hasDate, hasFrom: hasFrom)
            let ranges = spliceLog.nsranges(of: search)
            ranges.forEach { (range) in
                log.addAttributes([NSAttributedStringKey.backgroundColor : UIColor.yellow], range: range)
            }
        }
        
        return log.copy() as! NSAttributedString
    }
}
