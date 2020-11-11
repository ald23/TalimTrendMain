//
//  SelectionView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class SelectionView: UIView {
    
    var circleInside = SelectionCircleView()
    var selectionAction : (()->())?
    var isselected = false {
        didSet
        {
            if isselected{
                backgroundColor = #colorLiteral(red: 0.2274509804, green: 0.137254902, blue: 0.1725490196, alpha: 1)
                circleInside.isselected.toggle()
            }
            else {
                backgroundColor = .surface
                titleLabel.textColor = .boldTextColor
                circleInside.isselected.toggle()
            }
        }
    }
    var titleLabel : UILabel = {
        let label = UILabel()
            label.font = .getSourceSansProSemibold(of: 13)
            label.textColor = .boldTextColor
            
        return label
    }()
    
  
    init(title: String){
        super.init(frame: .zero)
        backgroundColor = .surface
        self.titleLabel.text = title
        layer.cornerRadius = 20
        let gesture = UITapGestureRecognizer(target: self, action: #selector(selection))
        addGestureRecognizer(gesture)
        setupView()
        
    }
    @objc func selection(){
        isselected.toggle()
        selectionAction?()
    }
    func setupView(){
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(24)
            make.top.equalTo(12)
        }
        addSubview(circleInside)
        circleInside.snp.makeConstraints { (make) in
            make.right.equalTo(-25)
            make.top.equalTo(12)
            make.width.height.equalTo(16)
        }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
