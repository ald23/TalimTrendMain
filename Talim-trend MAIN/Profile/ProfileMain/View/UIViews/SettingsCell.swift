//
//  SettingsCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class SettingsCell: UITableViewCell {
    var backView : UIView = {
        var backView = UIView()
            backView.layer.cornerRadius = 10
            backView.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.1764705882, alpha: 1)
        
        return backView
    }()
    var viewModel = ProfileViewModel()
    var nameOfCell : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 14)
            label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        
        return label
    }()
    var notificationsSwitch = CustomSwitch()
    var didFailToLogin = {() -> () in }
    var isOn = 1
    var languageLabel : UILabel = {
        var label = UILabel()
            label.text = UserManager.getCurrentLang()
            label.font = .getSourceSansProRegular(of: 12)
            label.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            label.isHidden = true
            
        return label
    }()
    var arrowImageView : UIImageView = {
        var imageView = UIImageView()
            imageView.image  = #imageLiteral(resourceName: "arrow")
            imageView.isHidden = true
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        contentView.isUserInteractionEnabled = false
        setup()
        notificationsSwitch.addTarget(self, action: #selector(notificationsToggle), for: .valueChanged)
      
    }
    
    @objc func notificationsToggle(){
        guard UserManager.isAuthorized() else {
            didFailToLogin()
            notificationsSwitch.isOn.toggle()
            notificationsSwitch.setupUI()
            return
        }
        viewModel.notificationToggle()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    func setupValues(section:Int,row: Int){
        if section == 0{
            if row == 0{
                nameOfCell.text = "Уведомления".localized()
                notificationsSwitch.isHidden = false
            }
            else {
                nameOfCell.text = "Язык".localized()
                languageLabel.isHidden = false
            }
        }
        else {
            arrowImageView.isHidden = false
            if row == 0{
                nameOfCell.text = "О нас".localized()
            }
            else if row == 1{
                nameOfCell.text = "Правила использования".localized()
            }
            else {
                nameOfCell.text = "Партнеры".localized()
            }
            
        }
    }
    
    func setup(){
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
            make.left.right.equalTo(0)
            make.height.equalTo(40)
        }
        backView.addSubview(nameOfCell)
        nameOfCell.snp.makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(11)
        }
        notificationsSwitch.isHidden = true
        backView.addSubview(notificationsSwitch)
        notificationsSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(12.5)
            make.right.equalTo(-13)
            make.width.equalTo(32)
            make.height.equalTo(17)
        }
       
        backView.addSubview(languageLabel)
        languageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.right.equalTo(-13)
        }
        backView.addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { (make) in
            make.width.equalTo(7)
            make.height.equalTo(12)
            make.top.equalTo(14)
            make.right.equalTo(-19)
        }
        
        
        
        
    }
}
