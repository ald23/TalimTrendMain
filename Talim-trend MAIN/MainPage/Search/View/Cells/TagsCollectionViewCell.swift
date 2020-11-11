//
//  TagsCollectionViewCell.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    lazy var tagLabel = UILabel()
    
    var isselected = false {
        didSet{
            if isselected {
                let gradiendLayer = CAGradientLayer.setGradientBackground()
                    gradiendLayer.frame = self.bounds
                    gradiendLayer.name = "gradient"
                    gradiendLayer.cornerRadius = 10
                    layer.insertSublayer(gradiendLayer, at: 0)
            }
            else {
                self.removeLayer(layerName: "gradient")
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .overlayDark
        
        setupViews()
        layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 
extension TagsCollectionViewCell: ViewInstallation {
    func addSubviews() {
        contentView.addSubview(tagLabel)
    }
    
    func addConstraints() {
        tagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.left.equalTo(9)
            
        }
    }
    
    func stylizeViews() {
        tagLabel.font = .getSourceSansProRegular(of: 12)
        tagLabel.textColor = .white
    }
    
    
}
