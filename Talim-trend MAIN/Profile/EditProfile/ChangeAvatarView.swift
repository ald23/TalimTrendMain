//
//  EditProfileView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class ChangeAvatarView: UIView {
    //MARK: - proporties
    var profileImageView : UIImageView = {
        var imageView = UIImageView()
            imageView.layer.cornerRadius = 40
            imageView.image = #imageLiteral(resourceName: "profile")
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
            imageView.backgroundColor = .overlayDark
            
        return imageView
    }()
    var changeAvatarAction : (()->())?

    var uploadImageButton : UIButton = {
        var button = UIButton()
        button.setTitle( "Изменить фото".localized(), for: .normal)
            button.setTitleColor(.grayForText, for: .normal)
            button.titleLabel?.font = .getSourceSansProRegular(of: 13)
        
        return button
    }()
    //MARK: - init
    override init(frame: CGRect){
        super.init(frame: .zero)
        setupView()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupAction(){
        uploadImageButton.addTarget(self, action: #selector(didTapOnChangeAvatar), for: .touchUpInside)
    }
    @objc func didTapOnChangeAvatar(){
        changeAvatarAction?()
    }
    //MARK: - setup
    func setupView(){
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.width.height.equalTo(80)
            
        }
        addSubview(uploadImageButton)
        uploadImageButton.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(17)
            make.bottom.equalTo(0)
        }
    }
    
}
