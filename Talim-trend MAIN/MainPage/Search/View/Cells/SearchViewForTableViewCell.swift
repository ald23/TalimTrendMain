//
//  searchViewForTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/22/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class SearchViewForTableViewCell: UIView {
    var recentlySearchedLabel : UILabel = {
        var label = UILabel()
        label.text = "Искали недавно".localized()
            label.font = .getSourceSansProSemibold(of: 15)
            label.textColor = .boldTextColor
        
        return label
    }()
    
    var clearAllBlock : (()->())?
    var clearAllButton : UIButton = {
        var button = UIButton()
            button.backgroundColor = .clear
            button.setTitle("Очистить все", for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1), for: .normal)
            button.titleLabel?.font = .getSourceSansProRegular(of: 12)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        clearAllButton.addTarget(self, action: #selector(clearAllTarget), for: .touchUpInside)
    }
    @objc func clearAllTarget(){
        clearAllBlock?()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        addSubview(recentlySearchedLabel)
        recentlySearchedLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(20)
            make.bottom.equalTo(-8)
        }
        addSubview(clearAllButton)
        clearAllButton.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(-4)
            make.top.equalToSuperview()
        }
    }
}

