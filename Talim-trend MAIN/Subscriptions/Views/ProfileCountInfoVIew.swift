//
//  ProfileCountInfoVIew.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class ProfileCountInfoVIew: UIView {

    private var videosCount = FollowersView(name: "видео", value: "")
    private var followersCount = FollowersView(name: "подписчиков", value: "")

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(videosCount)
        videosCount.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().dividedBy(3)
        }
        addSubview(followersCount)
        followersCount.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview().multipliedBy(1.3)
        }
    }
    
    func setupData(videosCount: Int, followersCount: Int) {
        self.videosCount.valueLabel.text = videosCount.description
        self.followersCount.valueLabel.text = followersCount.description
    }
}
