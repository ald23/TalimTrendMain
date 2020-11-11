//
//  MainPageTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import SDWebImage
import UIKit

class VideoTableViewCell: UITableViewCell {
    //MARK: variables
    var mainView : UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    var shareLink = ""
    var isFavorite = false
    var id = 0
         var videoThubnailImageView: UIImageView = {
            var imageView = UIImageView()
            
            imageView.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
            imageView.layer.cornerRadius = 20
          //  imageView.layer.masksToBounds = true
            imageView.clipsToBounds = true
            return imageView
        }()
         var videoTitle : UILabel = {
            var label = UILabel()
            label.font = .getSourceSansProSemibold(of: 15)
            label.text = "Шын дос қандай болады"
            label.textColor = UIColor(red: 0.971, green: 0.971, blue: 0.971, alpha: 0.9)
            label.numberOfLines = 0
            
            return label
        }()
//        var followButton = FollowButton()
         var durationLabel : UILabel = {
            var label = UILabel()
                label.font = .getSourceSansProRegular(of: 10)
                label.text = "10:00"
                label.textColor = .white
                label.backgroundColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
                label.layer.cornerRadius = 8
                label.layer.masksToBounds = true
                label.textAlignment = .center
                
            return label
        }()
        
     var typeOfVideoLabel : UILabel = {
        var label = UILabel()
        label.font = .getSourceSansProRegular(of: 12)
        label.text = "В тренде"
        label.backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.137254902, blue: 0.1725490196, alpha: 1)
        label.textColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        
        return label
    }()
         var channelProfileImage : UIImageView = {
            var imageView = UIImageView()
                imageView.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
                imageView.layer.cornerRadius = 16
                imageView.clipsToBounds = true
                
            return imageView
        }()
         var channelNameLabel : UILabel = {
            var label = UILabel()
            label.text = "Тәлім тренд"
            label.font = .getSourceSansProRegular(of: 15)
            label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            
            return label
         }()
    var numberOfViews = ImageAndTitleView(image: #imageLiteral(resourceName: "eye"),title: "20к")
    var timeReliseView = ImageAndTitleView(image: #imageLiteral(resourceName: "time"), title: "2 недели")
    var categoryView = ImageAndTitleView(image: #imageLiteral(resourceName: "category"), title: "Категория")
    var categories = ["Новинка","Премьера","В тренде"]
    var shareButton : UIButton = {
        var button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Vector-1"), for: .normal)
        
        
        return button
    }()
    
    var shareActionTarget = {( link : String, in_favorite : Bool, id : Int)->() in}
    //MARK:- init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupAction()
        contentView.isUserInteractionEnabled = false
        selectionStyle = .none
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        
        self.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.top.equalTo(10)
            make.left.right.equalToSuperview()
        }
        mainView.addSubview(videoThubnailImageView)
        videoThubnailImageView.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(170)
            make.top.equalTo(10)
            
        }
        mainView.addSubview(videoTitle)
        videoTitle.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(videoThubnailImageView.snp.bottom).offset(11)
            make.right.equalTo(-30)
        }
        videoThubnailImageView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-11)
            make.left.equalTo(13)
//            make.width.equalTo(34)
            make.height.equalTo(16)
        }
        videoThubnailImageView.addSubview(typeOfVideoLabel)
        typeOfVideoLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.right.equalTo(-12)
            make.width.equalTo(95)
            make.height.equalTo(24)
        }
        
        mainView.addSubview(numberOfViews)
        numberOfViews.snp.makeConstraints { (make) in
            make.top.equalTo(videoTitle.snp.bottom).offset(7)
            make.left.equalTo(videoTitle)
        }
        mainView.addSubview(timeReliseView)
        timeReliseView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberOfViews)
            make.left.equalTo(numberOfViews.snp.right).offset(10)
        }
        mainView.addSubview(categoryView)
        categoryView.snp.makeConstraints { (make) in
            make.centerY.equalTo(numberOfViews)
            make.left.equalTo(timeReliseView.snp.right).offset(10)
        }
        mainView.addSubview(channelProfileImage)
        channelProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(numberOfViews)
            make.width.height.equalTo(32)
            make.top.equalTo(numberOfViews.snp.bottom).offset(18)
            make.bottom.equalTo(-10)
        }
        mainView.addSubview(channelNameLabel)
        channelNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(channelProfileImage).offset(8)
            make.left.equalTo(channelProfileImage.snp.right).offset(8)
            
        }
//        addSubview(followButton)
//        followButton.snp.makeConstraints { (make) in
//            make.top.equalTo(videoThubnailImageView.snp.bottom).offset(72)
//            make.right.equalTo(-30)
//            make.width.equalTo(100)
//            make.height.equalTo(30)
//        }
        mainView.addSubview(shareButton)
        shareButton.snp.makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.bottom.right.equalTo(-20)
            
        }
    }
    
    private func setupAction() {
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
    }
    @objc func shareAction(){
        shareActionTarget(shareLink, isFavorite,id)
    }
    func hideAccountInfo() {
        channelProfileImage.isHidden = true
        channelNameLabel.isHidden = true
     //   followButton.isHidden = true
        
        numberOfViews.snp.remakeConstraints { (make) in
            make.top.equalTo(videoTitle.snp.bottom).offset(7)
            make.left.equalTo(videoTitle)
            make.bottom.equalTo(-10)
        }
    }
    
    func setupData(data: Video) {
        
        shareLink = data.path!.serverUrlString
        id = data.id
        if let favorite = data.is_favorite {
            isFavorite = favorite
        }
        if data.preview != nil {
        videoThubnailImageView.load(url: (data.preview ?? "").serverUrlString.url)
        }
        else {
            videoThubnailImageView.image = #imageLiteral(resourceName: "unnamed")
        }
        if data.status != nil {
            typeOfVideoLabel.text = data.status!
        }
        durationLabel.text = "  \(data.duration ?? "00:00")     " 
        if let author = data.author {
            if author.is_subscribed != nil{
        //    followButton.isselected = author.is_subscribed!
            }
            channelNameLabel.text = author.first_name + " " + author.last_name
            channelProfileImage.load(url: (author.avatar ?? "").serverUrlString.url)
        }
        
        videoTitle.text = data.name
        numberOfViews.imageTitle.text = data.number_of_views.description
        
        var time = data.created_at
        time.removeLast(8)
        if let time = time.getDate(){
            timeReliseView.imageTitle.text = time.daysOffset.replacingOccurrences(of: "-", with: "")
        }
       
        
        
        categoryView.imageTitle.text = data.category
        if  data.status_id != nil {
//        if categories.count > data.status_id!{
//        typeOfVideoLabel.text = categories[data.status_id! - 1]
//        }
        }
    }

}
