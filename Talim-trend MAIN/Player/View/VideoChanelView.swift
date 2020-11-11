//
//  VideochanelView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class VideoChanelView: UIView {
    
    private var topSeparatorView = UIView()
    private var chanelImageView = UIImageView()
    private var followButton = UIButton()
    private var chanelNameLabel = UILabel()
    private var chanelCountInfoLabel = UILabel()
    private var bottomSeparatorView = UIView()
    var failedToLogin = {() -> () in}
    let viewModel = SubscribeButtonViewModel()
    var currentVideoID = 0
    var isSubscribed : Bool = true {
        didSet {
            if isSubscribed{
                followButton.setImage(#imageLiteral(resourceName: "mobile-accept_major_monotone"), for: .normal)
                followButton.setGradient(cornerRadius: 15)
                followButton.setTitle(nil, for: .normal)
            }
            else {
                followButton.removeGradient()
                followButton.setImage(nil, for: .normal)
                followButton.setTitle("Подписаться".localized(), for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupAction()
        if isSubscribed {
            followButton.setImage(#imageLiteral(resourceName: "mobile-accept_major_monotone"), for: .normal)
        }

    }
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        self.addConstraints()
        self.layoutIfNeeded()
    }
    func setupAction(){
        followButton.addTarget(self, action: #selector(followAction), for: .touchUpInside)
    }
    @objc func followAction(){
        guard UserManager.isAuthorized() else {
            failedToLogin()
            return
        }
        viewModel.getSubscribe(id: currentVideoID, isAuthor: isSubscribed ? 0 : 1)
        isSubscribed.toggle()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Author) {
        chanelImageView.load(url: (data.avatar ?? "").serverUrlString.url)
        chanelNameLabel.text = data.first_name + " " + data.last_name
        chanelCountInfoLabel.text = "\(data.video_count!) видео   \(data.subscribers_count!) подписчиков"
    }
}

extension VideoChanelView {
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
    }
    
    private func addSubviews() {
        addSubview(topSeparatorView)
        addSubview(chanelImageView)
        addSubview(bottomSeparatorView)
        addSubview(followButton)
        addSubview(chanelNameLabel)
        addSubview(chanelCountInfoLabel)
    }
    
    private func addConstraints() {
        chanelImageView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.height.width.equalTo(38)
            make.top.equalTo(20)
            make.bottom.equalTo(-12)
        }
        
        topSeparatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(0.5)
        }
        
        bottomSeparatorView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(0.5)
        }
        
        followButton.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.width.equalTo(90)
        }
        
        chanelNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(chanelImageView.snp.right).offset(8)
            make.bottom.equalTo(chanelImageView.snp.centerY)
            make.right.equalTo(followButton.snp.left).offset(-12)
        }
        
        chanelCountInfoLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(chanelNameLabel)
            make.top.equalTo(chanelNameLabel.snp.bottom).offset(2)
        }

    }
    
    private func stylizeViews() {
        chanelImageView.layer.cornerRadius = 19
        chanelImageView.layer.masksToBounds = true
        
        chanelNameLabel.font = .getSourceSansProRegular(of: 15)
        chanelNameLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        
        chanelCountInfoLabel.font = .getSourceSansProRegular(of: 10)
        chanelCountInfoLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        
        followButton.layer.cornerRadius = 15
        
        followButton.backgroundColor = .overlayDark
        followButton.titleLabel?.font = .getSourceSansProRegular(of: 10)
        topSeparatorView.backgroundColor = #colorLiteral(red: 0.22, green: 0.231, blue: 0.251, alpha: 1)
        
        bottomSeparatorView.backgroundColor = #colorLiteral(red: 0.22, green: 0.231, blue: 0.251, alpha: 1)
    }
}
