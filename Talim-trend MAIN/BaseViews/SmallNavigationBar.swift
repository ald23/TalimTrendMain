//
//  SmallNavigationBar.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class SmallNavigationBar : UIView {
    
    var leftButtonImage : UIImage?
    
    lazy var leftButton : UIButton = {
        var button = UIButton()
            button.setImage(leftButtonImage, for: .normal)
            button.backgroundColor = .clear
            
        return button
    }()
    var leftButtonAction : (()->())?
    
    var navBarTitle: UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProSemibold(of: 15)
            label.textColor = .boldTextColor
            label.textAlignment = .center
        
        return label
    }()
    
    init(leftButtonImage : UIImage? = nil, title: String?){
        super.init(frame: .zero)
        self.leftButtonImage = leftButtonImage
        navBarTitle.text = title
        
        self.clipsToBounds = true
        self.backgroundColor = .overlayLight
        
        leftButton.addTarget(self, action: #selector(leftButtonTarget), for: .touchUpInside)
        setupViews()
    }
    @objc func leftButtonTarget(){
        leftButtonAction?()
    }
    func setupViews(){
        addSubview(navBarTitle)
        navBarTitle.snp.makeConstraints { (make) in
            make.top.equalTo(19)
            make.centerX.equalToSuperview()
        }
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.top.left.equalTo(18)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

