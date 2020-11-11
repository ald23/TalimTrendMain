//
//  CommentHeaderView.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class NextVideoView: UIView {

    var titleLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        self.addConstraints()
        self.layoutIfNeeded()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NextVideoView: ViewInstallation {
    func addSubviews() {
        addSubview(titleLabel)
        
    }
    
    func addConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(16)
            make.bottom.equalTo(-8)
        }
        

    }
    
    func stylizeViews() {
      
        titleLabel.textColor = #colorLiteral(red: 0.971, green: 0.971, blue: 0.971, alpha: 0.9)
        titleLabel.font = .getSourceSansProSemibold(of: 18)
        
     
    }
     
}
