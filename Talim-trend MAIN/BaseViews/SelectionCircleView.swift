//
//  SelectionCircleView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class SelectionCircleView : UIView {
    
    var circleInside : UIView = {
        var circle  = UIView()
            circle.backgroundColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            circle.layer.cornerRadius = 5
        
        return circle
    }()
    var isselected = false  {
        didSet {
            if isselected{
                self.layer.borderColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
                self.circleInside.isHidden = false
            }
            else {
                self.layer.borderColor = UIColor.boldTextColor.cgColor
                self.circleInside.isHidden = true
            }
        }
    }
    var action : (()->())?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        
        self.circleInside.isHidden = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.boldTextColor.cgColor
        
        layer.cornerRadius = 8
        
        let gesture = UIGestureRecognizer(target: self, action: #selector(actionTarget))
        addGestureRecognizer(gesture)
    }
    @objc func actionTarget(){
        action?()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(circleInside)
        circleInside.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.top.left.equalTo(3)
        }
    }
    
}


class SelectionCircleWithImage : UIView {
    
    var circleInside : UIImageView = {
        var circle  = UIImageView()
            circle.backgroundColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            circle.layer.cornerRadius = 5
            circle.image = #imageLiteral(resourceName: "Group 9121")
            circle.clipsToBounds = true
            circle.contentMode = .scaleAspectFill
        
        return circle
    }()
    var isselected = false  {
        didSet {
            if isselected{
                self.layer.borderColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
                self.circleInside.isHidden = false
            }
            else {
                self.layer.borderColor = UIColor.boldTextColor.cgColor
                self.circleInside.isHidden = true
            }
        }
    }
    var action : (()->())?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        clipsToBounds = true
        self.circleInside.isHidden = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.boldTextColor.cgColor
        
        layer.cornerRadius = 8
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(actionTarget))
        addGestureRecognizer(gesture)
        
    }
    @objc func actionTarget(){
        isselected.toggle()
        action?()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(circleInside)
        circleInside.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.edges.equalToSuperview()
        }
    }
    
}
