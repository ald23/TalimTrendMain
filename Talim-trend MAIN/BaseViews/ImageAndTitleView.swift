//
//  ImageTitle.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class ImageAndTitleView : UIView {
  
    private var imageView : UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    var imageTitle : UILabel = {
        var title = UILabel()
        title.font = .getSourceSansProRegular(of: 13)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.65)
        return title
    }()
    init(image:UIImage?, title:String?){
        super.init(frame : .zero)
        imageView.image = image
        imageTitle.text = title
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }
    func setupView()
    {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalTo(2)
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.width.height.equalTo(12)
           
        }
        addSubview(imageTitle)
        imageTitle.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(5)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview()
        }
        
        
    }
    
}
