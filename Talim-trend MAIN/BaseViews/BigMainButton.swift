//
//  BigMainButton.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

enum BackgroundType {
    case gradient
    case gray
}
class BigMainButton: UIButton {
    
    var action : (()->())?
    
    var background: BackgroundType
    
    init(title : String, background: BackgroundType) {
        self.background = background
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        titleLabel?.font = .getSourceSansProSemibold(of: 16)
        layer.cornerRadius = 20
        
        if background == .gray{
            setTitleColor(.grayForText, for: .normal)
            backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
        }
        addTarget(self, action: #selector(buttonTarget), for: .touchUpInside)
        
        
    }
    @objc func buttonTarget(){
        action?()
    }
    
    func setupButtonStyle() {
        if background == .gradient{
            setTitleColor(.white, for: .normal)
            let gradiendLayer: CAGradientLayer = .setGradientBackground()
            gradiendLayer.frame = self.bounds
            gradiendLayer.cornerRadius = 20
            layer.insertSublayer(gradiendLayer, at: 0)
        }
        else{
            setTitleColor(.grayForText, for: .normal)
            backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
