//
//  DJ.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/29.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import Foundation

class DJ {
    
    enum Mode: Int {
        case normal = 0
        case shuffle = 1
        case cycle = 2
    }
    
    //インスタンス
    public static let sheredInstance = DJ()
    //音楽リスト
    private let songs: [Song]
    //現在再生中の音楽
    private var currentNumber = -1
    //収録曲数
    private var songsCount: Int!
    //現在の再生設定
    var playMode: Mode = .normal
    
    private init() {
        songs = SongController().getSongs()
        songsCount = songs.count - 1
        playMode = .normal
    }

    
    func next() -> Song {
        switch playMode {
        case .normal, .cycle:
            if currentNumber == songsCount {
                currentNumber = 0
                return songs[currentNumber]
            }
            currentNumber += 1
            return songs[currentNumber]
        case .shuffle:
            return songs[shuffle()]
        }
    }
    
    func back() -> Song {
        switch playMode {
        case .normal, .cycle:
            if currentNumber == 0 {
                currentNumber = songsCount
                return songs[currentNumber]
            }
            currentNumber -= 1
            return songs[currentNumber]
        case .shuffle:
            return songs[shuffle()]
        }
    }
    
    func finishSong() -> Song {
        switch playMode {
        case .normal:
            if currentNumber == 0 {
                currentNumber = songsCount
                return songs[currentNumber]
            }
            currentNumber -= 1
            return songs[currentNumber]
        case .shuffle:
            return songs[shuffle()]
        case .cycle:
            return songs[currentNumber]
        }
    }
    
    private func shuffle() -> Int {
        while(true) {
            let random = Int.random(in: 0...songsCount)
            if currentNumber != random {
                currentNumber = random
                return random
            }
        }
    }
    
}
