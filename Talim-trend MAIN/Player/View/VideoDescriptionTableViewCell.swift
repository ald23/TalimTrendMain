//
//  ViewPlayerTitleView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import WebKit

class VideoDescriptionTableViewCell: UITableViewCell {

    var moreAction = {() -> () in}
    
    var titleLabel = UILabel()
    var moreButton = UIButton()
    var numberOfViews = ImageAndTitleView(image: #imageLiteral(resourceName: "eye"),title: "20к")
    var timeReliseView = ImageAndTitleView(image: #imageLiteral(resourceName: "time"), title: "2 недели")
    var categoryView = ImageAndTitleView(image: #imageLiteral(resourceName: "category"), title: "Категория")
 //   var playlistView = ImageAndTitleView(image: #imageLiteral(resourceName: "playlist (3) 1"), title: "Плэйлист")


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(data: Video) {
        self.titleLabel.text = data.name
        self.numberOfViews.imageTitle.text = "\(data.number_of_views)"
        var time = data.created_at
        time.removeLast(17)
        self.timeReliseView.imageTitle.text = time
        
        self.categoryView.imageTitle.text = "\(data.category)"
    }
    
    @objc func moreButtonAction() {
        if !moreButton.isHidden {
            moreAction()
            moreButton.isHidden.toggle()
        }
    }
}

extension VideoDescriptionTableViewCell {
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
        setupAction()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(moreButton)
        addSubview(numberOfViews)
        addSubview(timeReliseView)
        addSubview(categoryView)
     //   addSubview(playlistView)
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(8)
            make.right.equalTo(-50)
        }
        moreButton.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.height.equalTo(15)
            make.width.equalTo(25)
            make.centerY.equalTo(titleLabel)
        }
        numberOfViews.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(-8)
        }
        timeReliseView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(numberOfViews.snp.right).offset(12)
        }
        categoryView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.left.equalTo(timeReliseView.snp.right).offset(12)
        }
         
//        playlistView.snp.makeConstraints { (make) in
//            make.top.equalTo(titleLabel.snp.bottom).offset(7)
//            make.left.equalTo(categoryView.snp.right).offset(12)
//        }
    }
    
    private func stylizeViews() {
        backgroundColor = .base
        selectionStyle = .none
        contentView.isUserInteractionEnabled = false
        
        titleLabel.textColor = #colorLiteral(red: 0.971, green: 0.971, blue: 0.971, alpha: 0.9)
        titleLabel.numberOfLines = 0
        titleLabel.font = .getSourceSansProSemibold(of: 18)
        titleLabel.text = "Адамның жолының жабылуының ееең үлкен себебі..."
        
        moreButton.setTitle("еще".localized(), for: .normal)
        moreButton.titleLabel?.font = .getSourceSansProRegular(of: 12)
        moreButton.setTitleColor(#colorLiteral(red: 0.702, green: 0.243, blue: 0.424, alpha: 1), for: .normal)
        
    }
    
    func setupAction() {
        moreButton.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
    }
    
}
