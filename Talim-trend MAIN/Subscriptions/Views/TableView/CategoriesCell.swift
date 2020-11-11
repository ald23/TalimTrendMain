//
//  CategoriesCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/14/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class CategoriesCell: UITableViewCell {
    //MARK: - variables
    var subscribers_count: Int = 0 {
        didSet {
            self.followersCountLabel.text = "\(subscribers_count) подписчиков"
        }
    }
    var didFailToLogin = {() -> Void in }
    private var channelCategoryLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 17)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
            label.text = "Воспитание ребенка"
        
        return label
    }()
    private var videosCountLabel : UILabel = {
        var label = UILabel()
            label.text = "100 видео"
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9725490196, alpha: 0.9036012414)
        
        return label
    }()
    private var followersCountLabel : UILabel = {
        var label = UILabel()
            label.text = "135тыс. подписчиков"
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor  = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7)
        
        return label
    }()
    var followButton = FollowButton()
    override func layoutSubviews() {
        if isselected{
        followButton.setGradient(cornerRadius: 10)
        }
        else {
            followButton.removeGradient()
        }
    }
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupActions()
        self.contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        selectionStyle = .none
        
        addSubview(channelCategoryLabel)
        channelCategoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.left.equalTo(0)
        }
        
        addSubview(followersCountLabel)
        followersCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(channelCategoryLabel)
            make.top.equalTo(channelCategoryLabel.snp.bottom).offset(2)
            
        }
        
        addSubview(videosCountLabel)
        videosCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(followersCountLabel.snp.right).offset(10)
            make.centerY.equalTo(followersCountLabel)
            make.bottom.equalTo(-13)
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
    var isselected = false
    func setupData(data: Category) {
        isselected =  data.is_subscribed
        followButton.isselected = data.is_subscribed
        channelCategoryLabel.text = data.name
        videosCountLabel.text = "\(data.video_count) видео"
        self.subscribers_count = data.subscribers_count
    }
    
}
