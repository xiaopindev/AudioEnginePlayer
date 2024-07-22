//
//  SceneDelegate.swift
//  SwiftAudioEqualizer
//
//  Created by xiaopin on 2024/7/17.
//

import UIKit
import AVFoundation

class EqualizerViewController: UIViewController {
    lazy var audioEnginePlayer = AudioEnginePlayer()
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var labPlayProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioEnginePlayer.onPlaybackProgressUpdate = { [weak self] millseconds in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.slider.minimumValue = 0
                self.slider.maximumValue = Float(self.audioEnginePlayer.totalDuration)
                self.slider.value = Float(millseconds)
                self.labPlayProgress.text = "当前播放进度:\(millseconds)/\(self.audioEnginePlayer.totalDuration)"
                
            }
        }
        audioEnginePlayer.onPlayingIndexChanged = { playIndex in
            print("playIndex : \(playIndex)")
        }
        
        audioEnginePlayer.onPlayingStatusChanged = { isPlaying in
            print("isPlaying : \(isPlaying)")
        }
        
        audioEnginePlayer.onPlayCompleted = {
            print("onPlayCompleted");
        }
    }
    
    //均衡器设置
    @IBAction func adjustEqualizer(_ sender: UISlider) {
        let bandIndex = sender.tag - 1000;
        let gain = sender.value
        
        print("adjustEqualizer: \(bandIndex) \(gain)")
        audioEnginePlayer.setBandGain(bandIndex: bandIndex, gain: gain)
    }
    
    //随机混响
    var reverbId:Int = 0
    @IBAction func randomReverbAction(_ sender: Any) {
        reverbId += 1
        if (reverbId == 13){
            reverbId = 0
        }
        print("reverbId : \(reverbId)")
        audioEnginePlayer.setReverb(id: reverbId, wetDryMix: 50)
    }
    
    //恢复默认播放
    @IBAction func restoreAction(_ sender: Any) {
        audioEnginePlayer.resetAll()
        for i in 0..<10 {
            if let slider = view.viewWithTag(1000+i) as? UISlider{
                slider.setValue(0, animated: true)
            }
            
        }
    }
    
    //播放歌曲
    @IBAction func playAction(_ sender: Any) {
        // 播放在线音乐
        let audioUrl = "http://localhost/musics/%E9%99%88%E4%B9%90%E5%9F%BA%20-%20%E6%9C%88%E5%8D%8A%E5%B0%8F%E5%A4%9C%E6%9B%B2.mp3"
        audioEnginePlayer.play(with: audioUrl)
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        audioEnginePlayer.playOrPause()
    }
    
    @IBAction func prevAction(_ sender: Any) {
        audioEnginePlayer.playPrevious()
    }
    
    @IBAction func nextAction(_ sender: Any) {
        audioEnginePlayer.playNext()
    }
    
    @IBAction func singleLoopAction(_ sender: Any) {
        audioEnginePlayer.setLoopMode(.single)
    }
    
    @IBAction func loopAction(_ sender: Any) {
        audioEnginePlayer.setLoopMode(.all)
    }
    
    @IBAction func randomLoopAction(_ sender: Any) {
        audioEnginePlayer.setLoopMode(.shuffle)
    }
    
    @IBAction func setPlaylistAction(_ sender: Any) {
        // 海阔天空、月半小弯曲、墨尔本的秋天、暖一杯茶、奢香夫人
        let urls:[String] = [
            "http://192.168.1.163/musics/BEYOND%20-%20%E6%B5%B7%E9%98%94%E5%A4%A9%E7%A9%BA.mp3",
            "http://192.168.1.163/musics/%E9%99%88%E4%B9%90%E5%9F%BA%20-%20%E6%9C%88%E5%8D%8A%E5%B0%8F%E5%A4%9C%E6%9B%B2.mp3",
            "http://192.168.1.163/musics/%E5%A2%A8%E5%B0%94%E6%9C%AC%E7%9A%84%E7%A7%8B%E5%A4%A9.m4a",
            "http://192.168.1.163/musics/%E9%82%B5%E5%B8%85-%E6%9A%96%E4%B8%80%E6%9D%AF%E8%8C%B6.mp3",
            "http://192.168.1.163/musics/%E5%A5%A2%E9%A6%99%E5%A4%AB%E4%BA%BA.m4a",
        ]
        audioEnginePlayer.setPlaylist(urls, autoPlay: true)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        print("移动到：\(sender.value)")
        audioEnginePlayer.seekTo(milliseconds: Int(sender.value))
    }
    @IBAction func muteChanged(_ sender: UISwitch) {
        audioEnginePlayer.setIsMute(sender.isOn)
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        audioEnginePlayer.setVolume(sender.value)
    }
    
    @IBAction func speedChanged(_ sender: UISlider) {
        audioEnginePlayer.setSpeed(sender.value)
    }
    
}



