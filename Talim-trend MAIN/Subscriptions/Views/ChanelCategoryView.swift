//
//  ChanelCategoryView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class ChanelCategoryView: UIView {
    
    var subscribers_count: Int = 0 {
        didSet {
            self.followersCountLabel.text = "• \(subscribers_count) подписчиков"
        }
    }
    
    private var channelCategoryLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 17)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
        
        return label
    }()
    private var videosCountLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
        
        return label
    }()
    private var followersCountLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        return label
    }()
    private var channelProfileImage : UIImageView = {
        var imageView = UIImageView()
                
        return imageView
    }()
    var followButton = FollowButton()
    private var countOfVideos : UILabel = {
           var label = UILabel()
           label.text = "30 видео"
           label.textColor = .boldTextColor
           label.font = .getSourceSansProSemibold(of: 15)
        
           return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Category) {
        self.channelProfileImage.load(url: (data.preview ?? "").serverUrlString.url)
        self.channelCategoryLabel.text = data.name
        self.followButton.isselected = data.is_subscribed
        self.videosCountLabel.text = "\(data.video_count) видео"
        self.countOfVideos.text = "\(data.video_count) видео"
        self.subscribers_count = data.subscribers_count
    }
    
    private func setupViews(){
        addSubview(channelProfileImage)
        channelProfileImage.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        channelProfileImage.addSubview(videosCountLabel)
        videosCountLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-7)
            make.left.equalTo(17)
        }
        channelProfileImage.addSubview(followersCountLabel)
        followersCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(videosCountLabel)
            make.left.equalTo(videosCountLabel.snp.right).offset(10)
        }
        channelProfileImage.addSubview(channelCategoryLabel)
        channelCategoryLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(videosCountLabel.snp.top).offset(-4)
            make.left.equalTo(videosCountLabel)
            make.right.equalTo(-120)
        }
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.width.equalTo(100)
            make.height.equalTo(30)
            make.bottom.equalTo(channelProfileImage).offset(-14)
        }
        addSubview(countOfVideos)
        countOfVideos.snp.makeConstraints { (make) in
            make.top.equalTo(channelProfileImage.snp.bottom).offset(30)
            make.left.equalTo(16)
            make.bottom.equalTo(-16)
            
        }
    }
}

