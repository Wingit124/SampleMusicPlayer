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
            self.jacketImageView.layer.cornerRadius = jacketImageView.bounds.width / 20
        }
    }
    //音楽詳細ラベル
    @IBOutlet private weak var songTitleLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    //タイマーラベル
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var limitTimeLabel: UILabel!
    //スライダー
    @IBOutlet private weak var playbackSeekBar: PlaybackSlider! {
        didSet {
            self.playbackSeekBar.setThumbImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    @IBOutlet private weak var volumeSeekBar: UISlider!
    //再生ボタン
    @IBOutlet private weak var playButton: AnimationButton!
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
    //音楽をコントロールするクラス
    private let dj = DJ.sheredInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //一曲目をロード
        loadSong(song: dj.next())
        //現在の状態を保持
        playerState = .play        
    }
    
    @objc func setTimerLabel() {
        playbackSeekBar.value = playbackSeekBar.value + sliderDuration
        let limitTime = audioPlayer.duration - audioPlayer.currentTime
        currentTimeLabel.text = formatTimeString(time: audioPlayer.currentTime)
        limitTimeLabel.text = "-\(formatTimeString(time: limitTime))"
    }
    
    @IBAction func slidePlayBackFinished(_ sender: UISlider) {
        if !timer.isValid && playerState == .pause {
            self.timer = Timer.scheduledTimer(timeInterval: 1 / fps, target: self, selector: #selector(setTimerLabel), userInfo: nil, repeats: true)
        }
        if audioPlayer.isPlaying && sender.value == 1 {
            audioPlayer.currentTime = audioPlayer.duration - 1
            return
        }
        audioPlayer.currentTime = Double(sender.value) * audioPlayer.duration
    }
    
    @IBAction func slidePlayBack(_ sender: UISlider) {
        // sender.value : 1 = currentX : duration
        // sender.value * duration = currentX * 1
        timer.invalidate()
        let current = Double(sender.value) * audioPlayer.duration
        let limit = audioPlayer.duration - current
        currentTimeLabel.text = formatTimeString(time: current)
        limitTimeLabel.text = "-\(formatTimeString(time: limit))"
    }
    
    
    @IBAction func slideVolume(_ sender: UISlider) {
        audioPlayer.volume = sender.value
    }
    
    @IBAction func tapBackward(_ sender: Any) {
        loadSong(song: dj.back())
    }
    
    @IBAction func tapPlay(_ sender: AnimationButton) {
        if let audioPlayer = audioPlayer {
            if audioPlayer.isPlaying {
                playerState = .play
            } else {
                playerState = .pause
            }
        }
    }
    
    @IBAction func tapForward(_ sender: Any) {
        loadSong(song: dj.next())
    }
    
    @IBAction func tapSkip15Sec(_ sender: Any) {
        let duration = audioPlayer.duration - audioPlayer.currentTime
        if duration <= 15 {
            loadSong(song: dj.next())
            return
        }
        audioPlayer.currentTime += 15
        playbackSeekBar.value = Float(audioPlayer.currentTime / audioPlayer.duration)
        setTimerLabel()
    }
    
    @IBAction func tapPlayMode(_ sender: UIButton) {
        switch dj.playMode {
        case .normal:
            dj.playMode = .shuffle
            sender.setBackgroundImage(UIImage(systemName: "shuffle"), for: .normal)
            sender.tintColor = .systemPink
        case .shuffle:
            dj.playMode = .cycle
            sender.setBackgroundImage(UIImage(systemName: "repeat"), for: .normal)
            sender.tintColor = .systemPink
        case .cycle:
            dj.playMode = .normal
            sender.setBackgroundImage(UIImage(systemName: "increase.quotelevel"), for: .normal)
            sender.tintColor = .secondaryLabel
        }
    }
    
    @IBAction func tapBack15Sec(_ sender: Any) {
        audioPlayer.currentTime -= 15
        playbackSeekBar.value = Float(audioPlayer.currentTime / audioPlayer.duration)
        setTimerLabel()
    }
    
}

extension PlayerViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        loadSong(song: dj.finishSong())
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
        playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        animScaleChange(view: jacketImageView, duration: 0.7, scale: 0.8)
        audioPlayer.pause()
        timer.invalidate()
    }
    
    private func pause() {
        playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        animScaleChange(view: jacketImageView, duration: 0.7, scale: 1.0)
        audioPlayer.play()
        if !timer.isValid {
            self.timer = Timer.scheduledTimer(timeInterval: 1 / fps, target: self, selector: #selector(setTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    private func formatTimeString(time: Double) -> String {
        let second: Int = Int(time) % 60
        let minuts: Int = Int((time - Double(second))) / 60 % 60
        let hour: Int = Int(time - Double(minuts) - Double(second)) / 3600 % 3600
        if hour == 0 {
            let timeStr = String(format: "%02d:%02d", minuts, second)
            return timeStr
        } else {
            let timeStr = String(format: "%02d:%02d:%02d", hour, minuts, second)
            return timeStr
        }
    }
    
    private func animScaleChange(view: UIView, duration: TimeInterval, scale: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: [], animations: {
            view.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
}

