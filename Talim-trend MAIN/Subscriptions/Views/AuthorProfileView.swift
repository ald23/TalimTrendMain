//
//  AuthorProfileView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class AuthorProfileView: UIView {
    var videoCount: Int = 0 {
        didSet {
            self.countInfoView.setupData(videosCount: videoCount, followersCount: subscribers_count)
        }
    }
    
    var subscribers_count: Int = 0 {
        didSet {
            self.countInfoView.setupData(videosCount: videoCount, followersCount: subscribers_count)
        }
    }
    
    private var profileImage : UIImageView = {
        var imageView = UIImageView()
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private var countInfoView = ProfileCountInfoVIew()
    var followButton = FollowButton()
    private var authorsNameLabel : UILabel = {
        var label = UILabel()
        label.text = "Тәлім тренд"
        label.font = .getSourceSansProRegular(of: 17)
        label.textColor = .boldTextColor
        
        return label
    }()
    var descriptionView = AuthorDescriptionView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Author) {
        self.profileImage.load(url: (data.avatar ?? "").serverUrlString.url)
        self.authorsNameLabel.text = data.first_name + " " + data.last_name
        self.descriptionView.descriptionLabel.setAttributedHtmlText(data.description)
        self.descriptionView.descriptionLabel.textColor = .grayForText
        self.descriptionView.showHideMoreButton.isHidden = self.descriptionView.descriptionLabel.numberOfLines < 4
        self.followButton.isselected = data.is_subscribed!
        self.videoCount = data.video_count!
        self.subscribers_count = data.subscribers_count!
    }

    func setupViews(){
        addSubview(profileImage)
        profileImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.left.equalTo(17)
            make.top.equalTo(11)
            
        }
        addSubview(countInfoView)
        countInfoView.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(35)
            make.top.equalTo(22)
            make.right.equalTo(-16)            
        }
        
        addSubview(authorsNameLabel)
        authorsNameLabel.snp.makeConstraints{ (make)in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.left.equalTo(profileImage)
        }
        addSubview(followButton)
        followButton.snp.makeConstraints { (make) in
            make.top.equalTo(countInfoView.snp.bottom).offset(27)
            make.right.equalTo(-17)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { (make) in
            make.top.equalTo(authorsNameLabel.snp.bottom).offset(10)
            make.left.equalTo(authorsNameLabel)
            make.right.equalTo(followButton)
            make.bottom.equalToSuperview()
        }
    }
}






class FollowersView : UIView {
    private var nameOfSectionLabel  : UILabel = {
        let label = UILabel()
        label.font = .getSourceSansProSemibold(of: 12)
        label.textColor = .boldTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    var valueLabel : UILabel = {
        let label = UILabel()
        label.font = .getSourceSansProSemibold(of: 13)
        label.textColor = .grayForText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    init(name: String, value:String) {
        super.init(frame: .zero)
        nameOfSectionLabel.text = name
        valueLabel.text = value
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        addSubview(nameOfSectionLabel)
        nameOfSectionLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }

        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(nameOfSectionLabel.snp.top).offset(-4)
        }
        
    }
}
