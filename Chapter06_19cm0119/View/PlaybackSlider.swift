//
//  PlaybackSlider.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/23.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import UIKit

class PlaybackSlider: UISlider {
    
    var thumbImageView: UIImageView? {
        guard let image = self.currentThumbImage else { return nil }
        return self.subviews.compactMap({ $0 as? UIImageView }).first(where: { $0.image == image })
    }
    
    override func draw(_ rect: CGRect) {
        thumbImageView?.bounds.size = CGSize(width: 10, height: 10)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isTouchInside {
            animate(color: .systemPink, scale: 2.0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(color: .systemGray2, scale: 1.0)
    }
    
    private func animate(color: UIColor, scale: CGFloat) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            self.tintColor = color
            self.thumbImageView?.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }

}
