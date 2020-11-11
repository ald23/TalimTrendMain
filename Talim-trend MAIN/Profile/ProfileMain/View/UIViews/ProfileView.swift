//
//  ProfileView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

final class ProfileView: UIView {
    var profileImage : UIImageView = {
        var image = UIImageView()
            image.image = #imageLiteral(resourceName: "Group 10584")
            image.clipsToBounds = true
            image.layer.cornerRadius = 35
            image.contentMode = .scaleAspectFit
        
        return image
    }()
    var profileName : UILabel = {
        var label = UILabel()
            label.text = "Авторизуйтесь".localized()
            label.font = .getSourceSansProRegular(of: 17)
            label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        addSubview(profileImage)
        profileImage.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.height.equalTo(70)
        }
        addSubview(profileName)
        profileName.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(12)
            make.top.equalTo(15)
        }
    }
}
