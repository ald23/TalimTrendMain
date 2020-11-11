//
//  RecentlyWatchedCollectionViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class RecentlyWatchedCollectionViewCell: UICollectionViewCell {

    var videoThubnail : UIImageView = {
        var videoThubnail = UIImageView()
            videoThubnail.layer.cornerRadius = 20
            videoThubnail.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.3098039216, blue: 0.3098039216, alpha: 1)
            videoThubnail.clipsToBounds = true
        
        return videoThubnail
    }()
    var videoNameLabel : UILabel = {
        var videoNameLabel = UILabel()
            videoNameLabel.text = "Жаман қонақтың қауіпі қандай?"
            
            videoNameLabel.font = .getSourceSansProSemibold(of: 13)
            videoNameLabel.textColor = .boldTextColor
            videoNameLabel.numberOfLines = 0
        
        return videoNameLabel
    }()
    var durationLabel : UILabel = {
         var label = UILabel()
             label.font = .getSourceSansProRegular(of: 12)
             label.text = "10:00"
             label.textColor = .white
             label.backgroundColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
             label.layer.cornerRadius = 8
             label.layer.masksToBounds = true
             label.textAlignment = .center
         
         return label
     }()
    
    var numberOfViews = ImageAndTitleView(image: #imageLiteral(resourceName: "eye"),title: "20к")
    var timeReliseView = ImageAndTitleView(image: #imageLiteral(resourceName: "time"), title: "2 недели")
    var categoryView = ImageAndTitleView(image: #imageLiteral(resourceName: "category"), title: "Категория")

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupVideo(with video: Video){
            var time = video.duration
            time!.removeLast(3)
        
        durationLabel.text = time
        
            numberOfViews.imageTitle.text = String(describing: video.number_of_views)
        if let time = String(describing: video.created_at.dropLast(8)).getDate()?.daysOffset{
            
            timeReliseView.imageTitle.text = time.replacingOccurrences(of: "-", with: "")
        }
        
        
            categoryView.imageTitle.text = String(describing: video.category)
            videoNameLabel.text = String(describing: video.name)
            videoThubnail.load(url: (video.preview ?? "").serverUrlString.url)
        
        
    }
    func setupView(){
        addSubview(videoThubnail)
        videoThubnail.snp.makeConstraints { (make) in
            make.height.equalTo(110)
            make.width.equalTo(220)
            make.top.left.right.equalTo(0)
        }
        videoThubnail.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.bottom.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
        addSubview(videoNameLabel)
        videoNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(videoThubnail.snp.bottom).offset(7)
            make.left.equalTo(13)
            make.right.equalTo(0)
            
        }
        addSubview(numberOfViews)
        numberOfViews.snp.makeConstraints { (make) in
            make.top.equalTo(videoNameLabel.snp.bottom).offset(7)
            make.left.equalTo(videoNameLabel)
            make.bottom.equalTo(-8)
        }
        addSubview(timeReliseView)
        timeReliseView.snp.makeConstraints { (make) in
            make.top.equalTo(videoNameLabel.snp.bottom).offset(7)
            make.left.equalTo(numberOfViews.snp.right).offset(12)
        }
        addSubview(categoryView)
        categoryView.snp.makeConstraints { (make) in
            make.top.equalTo(videoNameLabel.snp.bottom).offset(7)
            make.left.equalTo(timeReliseView.snp.right).offset(12)
        }
    }
    
}
