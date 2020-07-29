//
//  JacketImageView.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/29.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import UIKit

class JacketImageView: UIImageView {
    
    var shadowView: UIView!

    override func draw(_ rect: CGRect) {
        print("aa")
        shadowView = UIView()
        shadowView.bounds = self.bounds
        shadowView.layer.cornerRadius = self.layer.cornerRadius
        shadowView.layer.shadowColor = UIColor.black.cgColor
        insertSubview(shadowView, at: 0)
    }

}
