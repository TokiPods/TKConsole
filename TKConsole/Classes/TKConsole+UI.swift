//
//  TKConsole+UI.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension Console {
    /// 在窗口上添加日志入口
    public static func addConsoleGateView(frame: CGRect? = nil, on window: UIWindow? = nil) {
        guard Console.shared.consoleGateView == nil else { return }
        
        Console.shared.keyWindow = window ?? TKWindow
        
        if let keyWindow = Console.shared.keyWindow, let consoleGateView = TKConsoleGateView.loadFromNib() {
            let consoleGateCenter = frame != nil ? CGPoint(x: frame!.minX, y: frame!.midY) : Console.shared.consoleGateCenter
            let consoleGateSize = frame != nil ? frame!.size : Console.shared.consoleGateSize
            
            consoleGateView.delegate = Console.shared
            consoleGateView.frame = CGRect(origin: CGPoint(x: consoleGateCenter.x - consoleGateSize.width/2,
                                                           y: consoleGateCenter.y - consoleGateSize.height/2),
                                           size: consoleGateSize)
            Console.shared.consoleGateView = consoleGateView
            keyWindow.addSubview(consoleGateView)
        }
    }
    
    /// 移除日志入口
    public static func removeConsoleGateView() {
        if let consoleGateView = Console.shared.consoleGateView {
            consoleGateView.removeFromSuperview()
            Console.shared.consoleGateView = nil
        }
    }
}

extension Console: TKConsoleGateViewDelegate, TKConsoleViewDelegate {
    /// 日志入口释放的回调
    public func dismiss(_ consoleGateView: TKConsoleGateView) {
        Console.closeConsoleGateView(center: consoleGateView.center)
    }
    
    /// 日志释放的回调
    public func dismiss(_ consoleView: TKConsoleView) {
        Console.closeConsoleView()
    }
}
