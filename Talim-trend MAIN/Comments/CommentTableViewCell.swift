//
//  CommentTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/26/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var userAvatarImageView : UIImageView = {
        var image = UIImageView()
            image.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            image.layer.cornerRadius = 18
            image.clipsToBounds = true
        
        return image
    }()
    var userNameLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProSemibold(of: 12)
            label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            label.text = "Maha the Developer"
        
        return label
    }()
    var dateView = ImageAndTitleView(image: #imageLiteral(resourceName: "time"), title: "2 недели")
    var commentLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 14)
            label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            label.text = "Ой жарайсыз аға! Сізге мың алғыс!"
        
        return label
    }()
    func setupData(comment : CommentModel){
        if let user = comment.user {
            userNameLabel.text = user.last_name + " " + user.first_name
            commentLabel.text = comment.text
            userAvatarImageView.load(url: (user.avatar ?? "").serverUrlString.url)
            comment.created_at.removeLast(8)
            
            if let date = comment.created_at.getDate()?.daysOffset {
                dateView.imageTitle.text = date.replacingOccurrences(of: "-", with: "")
            }
                
            
        }
 
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func setupView(){
        backgroundColor = .clear
        addSubview(userAvatarImageView)
        userAvatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.height.width.equalTo(36)
        }
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userAvatarImageView.snp.right).offset(5)
            make.top.equalTo(7)
        }
        addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            make.top.equalTo(userNameLabel)
            make.left.equalTo(userNameLabel.snp.right).offset(10)
            
        }
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userNameLabel)
            make.top.equalTo(userNameLabel.snp.bottom).offset(3)
        }
        
        
    }
    
}
