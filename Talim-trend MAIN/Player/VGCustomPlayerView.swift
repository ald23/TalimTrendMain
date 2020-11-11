//
//  VGCustomPlayerView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/18/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import VGPlayer
import AVFoundation
class VGCustomPlayerView: VGPlayerView {
    
    var playRate : Float = 1 {
        didSet {
            //need HELP - speed
            self.vgPlayer?.player?.playImmediately(atRate: playRate)
        }

    }

    let bottomProgressView : UIProgressView = {
        let progress = UIProgressView()
            progress.tintColor = .mainColor
            progress.isHidden = true
            
        return progress
    }()
    var presentSettingsAction = {()-> Void in }
    
    var subtitles : VGSubtitles?
    let subtitlesLabel = UILabel()
     var settingsButton = UIButton()
    
    override func configurationUI() {
        super.configurationUI()

        self.vgPlayer?.player?.rate = playRate
        self.titleLabel.isHidden = true
        self.titleLabel.removeFromSuperview()
        self.timeSlider.minimumTrackTintColor = .mainColor
        self.topView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.closeButton.setImage(#imageLiteral(resourceName: "Group 9034"), for: .normal)
        self.closeButton.isHidden = false
        
        self.addSubview(bottomProgressView)
        bottomProgressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(3)
        }
        //need HELP
        self.addSubview(settingsButton)
        settingsButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        settingsButton.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton)
            make.width.height.equalTo(closeButton)
            make.right.equalTo(-20)
        }
        
        settingsButton.addTarget(self, action: #selector(callSettings), for: .touchUpInside)
        

        
        subtitlesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        subtitlesLabel.numberOfLines = 0
        subtitlesLabel.textAlignment = .center
        subtitlesLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        subtitlesLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5031571062)
        subtitlesLabel.adjustsFontSizeToFitWidth = true
        self.insertSubview(subtitlesLabel, belowSubview: self.bottomView)
        
        subtitlesLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-5)
            make.left.equalTo(self).offset(5)
            make.bottom.equalTo(snp.bottom).offset(-10)
            make.centerX.equalTo(self)
        }
    }
    @objc func callSettings(){
        //play button
        self.vgPlayer?.pause()
        
        presentSettingsAction()
    }
    
    override func playStateDidChange(_ state: VGPlayerState) {
        super.playStateDidChange(state)
        if state == .playing {
            
            self.vgPlayer?.player?.playImmediately(atRate: playRate)
        }
    }
    
    override func displayControlView(_ isDisplay: Bool) {
        super.displayControlView(isDisplay)
        self.bottomProgressView.isHidden = isDisplay
    }
    
    override func reloadPlayerView() {
        super.reloadPlayerView()
        
       self.vgPlayer?.player?.rate = playRate

    }
    
    override func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        super.playerDurationDidChange(currentDuration, totalDuration: totalDuration)
        if let sub = self.subtitles?.search(for: currentDuration) {
            self.subtitlesLabel.isHidden = false
            self.subtitlesLabel.text = sub.content
        } else {
            self.subtitlesLabel.isHidden = true
        }
        self.bottomProgressView.setProgress(Float(currentDuration/totalDuration), animated: true)
    }
    
    open func setSubtitles(_ subtitles : VGSubtitles) {
        self.subtitles = subtitles
    }
    
    
    @objc func onRateButton() {
        switch playRate {
        case 1.0:
            playRate = 1.5
        case 1.5:
            playRate = 0.5
        default:
            playRate = 1.0
        }
        self.vgPlayer?.player?.rate = playRate
    }
    
    @objc func onMirrorFlipButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), -1, 1, 1)
        } else {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), 1, 1, 1)
        }
        updateDisplayerView(frame: self.bounds)
    }
    
}

