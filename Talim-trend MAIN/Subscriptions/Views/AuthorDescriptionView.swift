//
//  AuthorDescriptionView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
class  AuthorDescriptionView : UIView {
    var descriptionLabel: UILabel = {
        var label = UILabel()
            
            label.numberOfLines = 3
            label.font = .getSourceSansProRegular(of: 13)
            label.textColor = .grayForText
        
        return label
    }()
    var action : (()->())?
    lazy var showHideMoreButton: UIButton = {
        var button = UIButton()
        button.setButtonAttributeString("еще".localized())
            button.contentHorizontalAlignment = .left
        
        return button
    }()

    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAction()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupAction(){
        showHideMoreButton.addTarget(self, action: #selector(showAction(sender:)), for: .touchUpInside)
        
   }
   
   @objc func showAction(sender: UIButton) -> Void {
            descriptionLabel.numberOfLines = 0
            sender.isHidden = true
            action?()
    
   }
   private func getButtonAttributeString(_ string: String) -> NSAttributedString {
       return NSMutableAttributedString(string: string,
       attributes: [
           NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 13),
           NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1),
           NSAttributedString.Key.underlineColor:  #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1),
           ])
   }
    private func setupView(){
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(12)
            make.right.equalTo(-40)
            make.bottom.equalToSuperview().offset(-15)
        }
        addSubview(showHideMoreButton)
        showHideMoreButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(19)
            make.width.height.equalTo(40)
            make.right.equalTo(-6)
            
        }
    }
        
       
}
