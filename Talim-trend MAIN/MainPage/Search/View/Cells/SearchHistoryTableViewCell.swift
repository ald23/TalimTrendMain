//
//  SearchHistoryTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/22/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell {

    var searchIconImageView : UIImageView = {
        var image = UIImageView()
            image.image = #imageLiteral(resourceName: "recent-searches_major_monotone 1")
            image.clipsToBounds = true
        
        return image
    }()
    var searchLabel : UILabel = {
        var label = UILabel()
            label.text = "Достың төрт түрі болады"
            label.font = .getSourceSansProRegular(of: 14)
            label.textColor = .grayForText
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupData(comment: SearchHistoryModel){
        searchLabel.text = comment.text
    }
    func setupViews(){
        addSubview(searchIconImageView)
        searchIconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(2)
            make.left.equalTo(20)
            make.width.height.equalTo(16)
        }
        addSubview(searchLabel)
        searchLabel.snp.makeConstraints { (make) in
            make.top.equalTo(searchIconImageView)
            make.left.equalTo(searchIconImageView.snp.right).offset(8)
        }
        
    }
    
}
