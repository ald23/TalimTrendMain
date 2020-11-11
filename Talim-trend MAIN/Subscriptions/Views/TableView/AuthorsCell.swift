//
//  AuthorsCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class AuthorsCell: UITableViewCell {
    
    var subscribers_count: Int = 0 {
        didSet {
            followersCountLabel.text = "\(subscribers_count) подписчиков"
        }
    }
    private let imageProfileView: UIImageView = {
        let imageView = UIImageView()
            imageView.layer.cornerRadius = 23
            imageView.layer.masksToBounds = true
            imageView.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
        
        return imageView
    }()
    private var authorsNameLabel: UILabel = {
        var label = UILabel()
            label.text = "Игорь Войтенко"
            label.font = .getSourceSansProRegular(of: 17)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
        return label
    }()
    private var videosCountLabel: UILabel = {
        var label = UILabel()
            label.text = "100 видео"
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
        
        return label
    }()
    private var followersCountLabel: UILabel = {
        var label = UILabel()
            label.text = "135тыс. подписчиков"
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        return label
    }()
    var isselected = false {
        didSet {
//            followButton.isselected = isselected
//            isselected ? followButton.removeGradient() : followButton.setupButtonAppearance()
            
        }
    }
    var followButton = FollowButton()
    override func layoutSubviews() {
        if isselected{
        followButton.setGradient(cornerRadius: 10)
        }
        else {
            followButton.removeGradient()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupActions()
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        selectionStyle = .none
        
        addSubview(imageProfileView)
        imageProfileView.snp.makeConstraints { (make) in
            make.height.width.equalTo(46)
            make.left.equalToSuperview()
            make.top.equalTo(13)
            make.bottom.equalTo(-13)
        }
        addSubview(authorsNameLabel)
        authorsNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageProfileView.snp.right).offset(12)
            make.top.equalTo(13)
        }
        addSubview(followersCountLabel)
        followersCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(authorsNameLabel)
            make.top.equalTo(authorsNameLabel.snp.bottom).offset(2)
            
        }
        addSubview(videosCountLabel)
        videosCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(followersCountLabel.snp.right).offset(10)
            make.centerY.equalTo(followersCountLabel)
//            make.bottom.equalTo(-10)
        }
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.right.equalTo(0)
            make.width.equalTo(100)
            make.height.equalTo(30)
         }
    }
    
    private func setupActions() {
    }
    
    func setupData(data: Author) {
        self.isselected = data.is_subscribed!
        followButton.isselected = data.is_subscribed!
        authorsNameLabel.text = "\(data.first_name) \(data.last_name)"
        videosCountLabel.text = "\(data.video_count!) видео"
        subscribers_count = data.subscribers_count!
        imageProfileView.load(url: (data.avatar ?? "").serverUrlString.url)
    }

}
