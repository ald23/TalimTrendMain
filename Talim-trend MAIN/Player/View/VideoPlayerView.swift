//
//  VideoPlayerView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import VGPlayer

protocol PopNavigateDelegate {
    func popNavigate(animated: Bool)
}


class VideoPlayerView: UIView {
    
    var delegate: PopNavigateDelegate?
    let playerView = VGCustomPlayerView()

    var player : VGPlayer
    
    override init(frame: CGRect) {
        self.player = VGPlayer(playerView: playerView)
        super.init(frame: .zero)
        setupViews()
     
    }
    
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        addConstraints()
        self.layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func play() {
        self.player.play()
        
    }
    
    func pause() {
        self.player.pause()
    }
    
    func showHideControlViews(bool: Bool = false) {
        playerView.displayControlView(bool)
    }
}

// MARK: - VGPlayerDelegate
extension VideoPlayerView: VGPlayerDelegate {
    func vgPlayer(_ player: VGPlayer, playerFailed error: VGPlayerError) {
        print(error)
    }
    func vgPlayer(_ player: VGPlayer, stateDidChange state: VGPlayerState) {
        print("player State ",state)
    }
    func vgPlayer(_ player: VGPlayer, bufferStateDidChange state: VGPlayerBufferstate) {
        print("buffer State", state)
    }
}


// MARK: - VGPlayerViewDelegate
extension VideoPlayerView: VGPlayerViewDelegate {
    func vgPlayerView(_ playerView: VGPlayerView, willFullscreen fullscreen: Bool) {
        
    }
    func vgPlayerView(didTappedClose playerView: VGPlayerView) {
        if playerView.isFullScreen {
            playerView.exitFullscreen()
        } else {
            self.delegate?.popNavigate(animated: true)
        }
        
    }
    func vgPlayerView(didDisplayControl playerView: VGPlayerView) {
        UIApplication.shared.setStatusBarHidden(!playerView.isDisplayControl, with: .fade)
        
    }
}

extension VideoPlayerView {
    
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
        setupPlayerView()
    }
    
    private func addSubviews() {
        addSubview(self.player.displayView)
    }
    
    private func addConstraints() {
        self.player.displayView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
       
        }
        
    }
    
    private func stylizeViews() {
        backgroundColor = .black
        tintColor = .clear
    }
    
    private func setupPlayerView() {
        if  let srt = Bundle.main.url(forResource: "Despacito Remix Luis Fonsi ft.Daddy Yankee Justin Bieber Lyrics [Spanish]", withExtension: "srt") {
            let playerView = self.player.displayView as! VGCustomPlayerView
            playerView.setSubtitles(VGSubtitles(filePath: srt))
        }
        
        let url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!
        self.player.replaceVideo(url)
        self.player.play()
        self.player.backgroundMode = .suspend
        self.player.delegate = self
        self.player.displayView.delegate = self
        
    }
    
    func startPlay(by url: String) {
        guard let url = URL(string: url) else { return }
        
        self.player.replaceVideo(url)
        self.player.play()
        self.player.backgroundMode = .suspend
      
        self.player.delegate = self
        self.player.displayView.delegate = self
    }

    private func setupObserve() {
    }
}

