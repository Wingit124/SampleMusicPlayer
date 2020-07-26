//
//  Song.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/22.
//  Copyright © 2020 高橋翼. All rights reserved.
//
import Foundation

struct Song {
    let songName: String
    let artistName: String
    let fileName: String
    let jacketName: String
}

class SongController {
    
    func getSongs() -> [Song] {
        let components = songData.components(separatedBy: CharacterSet.newlines)
        var songs = [Song]()
        for line in components {
            let songConponents = line.components(separatedBy: ",")
            let songName = songConponents[0]
            let artistName = songConponents[1]
            let fileName = songConponents[2]
            let jacketName = songConponents[3]
            songs.append(Song(songName: songName, artistName: artistName, fileName: fileName, jacketName: jacketName))
        }
        return songs
    }
    
}


let songData = """
サンプル音源1,不明,sound01,image01
サンプル音源2,不明,sound02,image02
"""
