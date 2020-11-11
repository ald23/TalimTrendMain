//
//  NavigationBarView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class NavigationBarView: UIView {
    
    var rightButtonImage: UIImage?
    var leftButtonImage: UIImage?
    var rightButtonNeighborImage : UIImage?
    
    var leftButtonAction: (() -> ())?
    var rightButtonTarget: (() -> ())?
    var rightButtonNeighborAction : (()->())?
    
    lazy var leftButton: UIButton = {
        let button = UIButton()
            button.setImage(leftButtonImage, for: .normal)
            button.contentMode = .scaleAspectFit
            button.imageEdgeInsets.top = 1
            button.imageEdgeInsets.left = 1
            button.imageEdgeInsets.right = -1
            button.imageEdgeInsets.bottom = -1
            button.layer.cornerRadius = 13
            button.backgroundColor = .overlayDark
        
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
            button.setImage(rightButtonImage, for: .normal)
            button.backgroundColor = .overlayDark
            button.contentMode = .scaleAspectFit
            button.layer.cornerRadius = 13
            button.imageEdgeInsets.top = 1
            button.imageEdgeInsets.left = 1
            button.imageEdgeInsets.right = -1
            button.imageEdgeInsets.bottom = -1
        
        return button
    }()
    
    lazy var rightButtonNeighborButton: UIButton = {
        let button = UIButton()
            button.setImage(rightButtonNeighborImage, for: .normal)
            button.contentMode = .scaleAspectFit
            button.imageEdgeInsets.top = 1
            button.imageEdgeInsets.left = 1
            button.imageEdgeInsets.right = -1
            button.imageEdgeInsets.bottom = -1
            button.layer.cornerRadius = 13
            button.backgroundColor = .overlayDark
        
        return button
    }()
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
            label.textColor = .white
            label.font = label.font.withSize(18)
            label.textAlignment = .center
        
        return label
    }()
    
    //    MARK: - Initialization
    
    init(title: String = "", rightButtonImage: UIImage? = nil, leftButtonImage:UIImage? = nil,rightButtonNeighborImage : UIImage? = nil) {
        super.init(frame: .zero)
        
        self.rightButtonImage = rightButtonImage
        self.leftButtonImage = leftButtonImage
        self.rightButtonNeighborImage = rightButtonNeighborImage
        rightButtonNeighborButton.setImage(rightButtonNeighborImage, for: .normal)
      
        self.titleLabel.text = title
        
        setupAction()
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - Setup function
    private func setupAction(){
        leftButton.addTarget(self, action: #selector(leftButtonActionButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonAction), for: .touchUpInside)
        rightButtonNeighborButton.addTarget(self, action: #selector(rightButtonNeighborButtonTarget), for: .touchUpInside)
            
    }
    private func setupView() -> Void {
        self.backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        
        self.rightButtonNeighborButton.isHidden  = rightButtonNeighborImage == nil
        self.leftButton.isHidden = leftButtonImage == nil
        self.rightButton.isHidden = self.rightButtonImage == nil
        
    
        addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(AppConstants.navBarHeight*4/5)
        }
        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(leftButton)
        }
        if rightButtonNeighborImage != nil {
            addSubview(rightButtonNeighborButton)
            rightButtonNeighborButton.snp.makeConstraints { (make) in
                make.width.height.equalTo(leftButton)
                make.centerY.equalToSuperview()
                make.right.equalTo(rightButton.snp.left).offset(-12)
            }
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.centerX.equalToSuperview()
            make.left.equalTo(leftButton.snp.right).offset(2)
            make.right.equalTo(rightButtonNeighborImage != nil ? rightButtonNeighborButton.snp.left : rightButton.snp.left).offset(-2)
        }
    }
    
    @objc func leftButtonActionButton() -> Void {
        self.leftButtonAction?()
    }
    
    @objc func rightButtonAction() -> Void {
        self.rightButtonTarget?()
    }
    @objc func rightButtonNeighborButtonTarget(){
        rightButtonNeighborAction?()
    }
}
