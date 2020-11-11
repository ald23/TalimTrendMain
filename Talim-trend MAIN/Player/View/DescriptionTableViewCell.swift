//
//  WebVIewTableViewCell.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import WebKit
class DescriptionTableViewCell: UITableViewCell {


    var label: UILabel = {
        var label = UILabel()
            label.textColor = .grayForText
            label.font = .getSourceSansProRegular(of: 14)
            label.numberOfLines = 0
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-5)
        }
    }
    
    func setupData(data: Video) {
        guard let text = data.description else {
            return
        }
        self.label.text = text
        
    }

}

