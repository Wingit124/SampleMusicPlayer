//
//  PlayButton.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/22.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import UIKit

class PlayButton: AnimationButton {

    var playState: PlayerState = .play {
        didSet {
            setValue(state: playState)
        }
    }
    
    private func setValue(state: PlayerState) {
        
        switch state {
        case .play:
            self.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        case .pause:
            self.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        
    }
    
}
