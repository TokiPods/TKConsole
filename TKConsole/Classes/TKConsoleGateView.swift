//
//  TKConsoleGateView.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/5/27.
//

import UIKit

public protocol TKConsoleGateViewDelegate: class {
    func dismiss(_ consoleGateView: TKConsoleGateView)
}

open class TKConsoleGateView: UIView {
    static let nibName = "TKConsoleGateView"
    
    public weak var delegate: TKConsoleGateViewDelegate?
    
    var isDragging: Bool = false
    var touchOffset: CGPoint = CGPoint.zero
    
    lazy var blockingView: UIView = {
        let temp = UIView()
        return temp
    }()

    open static func loadFromNib() -> TKConsoleGateView? {
        let nib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return nib?.first as? TKConsoleGateView
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        self.delegate?.dismiss(self)
    }
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDragging {
            if let touchPoint = touches.first?.location(in: TKWindow) {
                    frame = CGRect(origin: CGPoint(x: touchPoint.x - touchOffset.x, y: touchPoint.y - touchOffset.y),
                                   size: frame.size)
            }
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TKWindow?.bringSubview(toFront: self)
        
        isDragging = true
        touchOffset = touches.first?.location(in: self) ?? touchOffset
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }
    
}
