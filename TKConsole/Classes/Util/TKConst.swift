//
//  TKConst.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/5/27.
//

import Foundation

let TKLogFilePrefix = "TKConsole_Log_"
let TKLogFileSuffix = ".plist"

let TKLogDirPath: String = {
    NSHomeDirectory().appending("/Documents/")
}()

let TKConsoleBundlePath: String = Bundle.main.bundlePath+"/Frameworks/TKConsole.framework/TKConsole.bundle"
let TKConsoleBundle: Bundle? = Bundle(path: TKConsoleBundlePath)

var TKWindow: UIWindow? {
    get {
        return UIApplication.shared.keyWindow
    }
}
