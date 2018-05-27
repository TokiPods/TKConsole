//
//  TKConsoleGateView.swift
//  Pods-TKConsole_Example
//
//  Created by zhengxianda on 2018/5/27.
//

import UIKit

class TKConsoleGateView: UIView {
    static let nibName = "TKConsoleGateView"
    
    var isDragging: Bool = false
    var touchOffset: CGPoint = CGPoint.zero
    
    lazy var blockingView: UIView = {
        let temp = UIView()
        return temp
    }()

    static func loadFromNib() -> TKConsoleGateView? {
        let gateNib = TKConsoleBundle?.loadNibNamed(nibName, owner: nil, options: nil)
        return gateNib?.first as? TKConsoleGateView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    @objc func tap() {
        if let window = TKWindow {
            blockingView.frame = window.frame
            window.insertSubview(blockingView, belowSubview: self)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.frame = CGRect(origin: CGPoint(x: self.frame.midX, y: self.frame.midY),
                                    size: CGSize.zero)
            }) { (completion) in
                if completion {
                    self.blockingView.removeFromSuperview()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isDragging {
            if let touchPoint = touches.first?.location(in: TKWindow) {
                    frame = CGRect(origin: CGPoint(x: touchPoint.x - touchOffset.x, y: touchPoint.y - touchOffset.y),
                                   size: frame.size)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TKWindow?.bringSubview(toFront: self)
        
        isDragging = true
        touchOffset = touches.first?.location(in: self) ?? touchOffset
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isDragging = false
    }
    
}
