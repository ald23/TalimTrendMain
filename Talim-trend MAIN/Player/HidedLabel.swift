//
//  HidedLabel.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/19/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class HidenLabelView: UIView {
    
    var titleLabel = UILabel()
    var chanelTitleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HidenLabelView {
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(chanelTitleLabel)
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(2)
            
        }
        chanelTitleLabel.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            
        }
    }
    
    private func stylizeViews() {
        
        titleLabel.font = .getSourceSansProSemibold(of: 12)
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        titleLabel.numberOfLines = 2

        chanelTitleLabel.font = .getSourceSansProSemibold(of: 11)
        chanelTitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        chanelTitleLabel.numberOfLines = 1
    }
    
    func setupData(data: VideoDetailModel) {
        self.titleLabel.text = data.video.name
        self.chanelTitleLabel.text = data.author.first_name + " " + data.author.last_name
    }
    
}
