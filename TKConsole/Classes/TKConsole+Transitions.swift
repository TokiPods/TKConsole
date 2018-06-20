//
//  TKConsole+Transitions.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/6/20.
//

import Foundation

extension Console {
    
    static func showConsoleGateView(center: CGPoint? = nil, size: CGSize? = nil) {
        Console.shared.consoleGateCenter = center ?? Console.shared.consoleGateCenter
        Console.shared.consoleGateSize = size ?? Console.shared.consoleGateSize
        
        if let window = Console.shared.keyWindow, let consoleGateView = Console.shared.consoleGateView ?? TKConsoleGateView.loadFromNib() {
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
        
        if let window = Console.shared.keyWindow, let consoleGateView = Console.shared.consoleGateView {
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
        
        if let window = Console.shared.keyWindow, let consoleView = Console.shared.consoleView ?? TKConsoleView.loadFromNib() {
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
        
        if let window = Console.shared.keyWindow, let consoleView = Console.shared.consoleView {
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
