//
//  ViewController.swift
//  Chapter06_19cm0119
//
//  Created by 高橋翼 on 2020/07/22.
//  Copyright © 2020 高橋翼. All rights reserved.
//

import UIKit
import AVFoundation

//プレイヤーの状態
enum PlayerState: Int {
    case play = 0
    case pause = 1
}

class PlayerViewController: UIViewController {
    //ジャケット画像
    @IBOutlet private weak var jacketImageView: UIImageView! {
        didSet {
            self.jacketSize = jacketImageView.frame.size
            self.jacketImageView.layer.cornerRadius = jacketImageView.bounds.width / 20
        }
    }
    private var jacketSize: CGSize!
    //音楽詳細ラベル
    @IBOutlet private weak var songTitleLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    //タイマーラベル
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var limitTimeLabel: UILabel!
    //スライダー
    @IBOutlet private weak var playbackSeekBar: PlaybackSlider! {
        didSet {
            self.playbackSeekBar.setThumbImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    @IBOutlet private weak var volumeSeekBar: UISlider!
    //再生ボタン
    @IBOutlet private weak var playButton: PlayButton!
    //プレイヤー
    private var audioPlayer: AVAudioPlayer!
    private var sliderDuration: Float = 0.0
    private let fps = 60.0
    private var timer = Timer()
    //現在の状態
    private var playerState: PlayerState = .play {
        didSet {
            switch playerState {
            case .play:
                play()
            case .pause:
                pause()
            }
        }
    }
    //音楽が入ってる配列
    private let songs = SongController().getSongs()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //一曲目をロード
        loadSong(song: songs[0])
        //現在の状態を保持
        playerState = .play
    }
    
    @objc func setTimerLabel() {
        playbackSeekBar.value = playbackSeekBar.value + sliderDuration
        currentTimeLabel.text = audioPlayer.currentTime.description
        let limitTime = round(audioPlayer.duration) - audioPlayer.currentTime
        limitTimeLabel.text = "-\(limitTime)"
    }
    
    @IBAction func slidePlayBackFinished(_ sender: UISlider) {
        if audioPlayer.isPlaying && sender.value == 1 {
            audioPlayer.currentTime = audioPlayer.duration - 1
            return
        }
        audioPlayer.currentTime = Double(sender.value) * audioPlayer.duration
    }
    
    @IBAction func slidePlayBack(_ sender: Any) {
        print("aaa")
    }
    
    
    @IBAction func slideVolume(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    @IBAction func tapBackward(_ sender: Any) {
        loadSong(song: songs[0])
    }
    
    @IBAction func tapPlay(_ sender: PlayButton) {
        print(playerState)
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                playerState = .play
            } else {
                playerState = .pause
            }
        }
    }
    
    @IBAction func tapForward(_ sender: Any) {
        switch playerState {
        case .play:
            loadSong(song: songs[1])
        case .pause:
            playbackSeekBar.value = 1
            audioPlayer.currentTime = audioPlayer.duration - 1
        }
    }
    
}

extension PlayerViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        loadSong(song: songs[1])
    }
    
}

extension PlayerViewController {
    //曲のロードをする
    private func loadSong(song: Song) {
        if let sound = NSDataAsset(name: song.fileName) {
            do {
                audioPlayer = try AVAudioPlayer(data: sound.data)
            } catch {
                print(error)
                exit(99)
            }
            //プレイヤーの設定
            audioPlayer.delegate = self
            //音量の設定
            audioPlayer.volume = volumeSeekBar.value
            //ビューの設定
            songTitleLabel.text = song.songName
            artistNameLabel.text = song.artistName
            jacketImageView.image = UIImage(named: song.jacketName)
            //時間ラベルをセット
            setTimerLabel()
            //シークバーの設定
            sliderDuration = Float(1.0 / audioPlayer.duration / fps)
            playbackSeekBar.value = 0.0
            //状態によって再生するか変える
            switch playerState {
            case .play: play()
            case .pause: pause()
            }
        }
    }
    
    private func play() {
        playButton.playState = .play
        animScaleChange(view: jacketImageView, duration: 0.7, scale: 0.8)
        audioPlayer.pause()
        timer.invalidate()
    }
    
    private func pause() {
        playButton.playState = .pause
        animScaleChange(view: jacketImageView, duration: 0.7, scale: 1.0)
        audioPlayer.play()
        if !timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 1 / fps, target: self, selector: #selector(setTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    private func animScaleChange(view: UIView, duration: TimeInterval, scale: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
}

