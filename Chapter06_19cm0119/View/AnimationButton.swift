//
//  AnimationButton.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/23.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import UIKit

class AnimationButton: UIButton {
    
    var highlighteView: UIView!
    var timer: Timer!
    
    override func draw(_ rect: CGRect) {
        let width = rect.width * 1.5
        let height = rect.height * 1.5
        let viewRect = CGRect(x: -width / 6, y: -height / 6, width: width, height: height)
        highlighteView = UIView(frame: viewRect)
        highlighteView.backgroundColor = .systemGray
        highlighteView.layer.cornerRadius = width / 2
        highlighteView.alpha = 0
        self.addSubview(highlighteView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(scale: 0.8, alpha: 0.3)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //一瞬だけ押した場合でもアニメーションが全て実行されるようになってる
        if highlighteView.layer.animationKeys() == nil {
            animate(scale: 1, alpha: 0)
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                if self.highlighteView.layer.animationKeys() == nil {
                    self.timer.invalidate()
                    self.animate(scale: 1, alpha: 0)
                }
            })
        }
    }
    
    private func animate(scale: CGFloat, alpha: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            self.highlighteView.alpha = alpha
        }, completion: nil)

    }
    
}
