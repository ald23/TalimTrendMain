//
//  FollowButton.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/14/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class FollowButton: UIButton {

    var isselected = false {
        didSet {
             
            if isselected {
                let gradiendLayer: CAGradientLayer = .setGradientBackground()
                gradiendLayer.frame = self.bounds
                gradiendLayer.name = "gradient"
                self.setTitle("Подписки".localized(), for: .normal)
                self.layer.insertSublayer(gradiendLayer, at: 0)
                setTitleColor(.white, for: .normal)
            }
            else {
                removeLayer(layerName: "gradient")
                setTitle("Подписаться".localized(), for: .normal)
            }
        
        }
    }
    var selectionBlock: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
        titleLabel?.font = .getSourceSansProRegular(of: 12)
        self.addTarget(self, action: #selector(followAction), for: .touchUpInside)
        setupButtonAppearance()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupButtonAppearance(){
         
        if isselected {
            let gradiendLayer: CAGradientLayer = .setGradientBackground()
                gradiendLayer.frame = self.bounds
                gradiendLayer.name = "gradient"
                self.setTitle("Подписки".localized(), for: .normal)
                self.layer.insertSublayer(gradiendLayer, at: 0)
                setTitleColor(.white, for: .normal)
        }
        else {
                removeLayer(layerName: "gradient")
                setTitle("Подписаться".localized(), for: .normal)
                setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func followAction() {
        selectionBlock?()
    }
}
