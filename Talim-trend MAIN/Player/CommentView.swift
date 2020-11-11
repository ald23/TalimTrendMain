//
//  CommentView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/3/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class CommentView: UIView {
    var commentLabel : UILabel = {
        var label = UILabel()
            label.textColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            label.font = .getSourceSansProSemibold(of: 15)
            label.text = "Комментировать".localized()
        
        return label
    }()
    var backView : UIView = {
        var view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.1764705882, alpha: 1)
        
        return view
    }()
    var videoLabel : UILabel = {
        var label = UILabel()
            label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            label.font = .getSourceSansProSemibold(of: 15)
            label.text = " видео"
        
        return label
    }()
    func remakeConstraintsAfterFlip(){
        self.removeAllConstraints()
        self.layoutIfNeeded()
        self.setupViews()
        self.layoutIfNeeded()
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    func setupViews(){
        addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
         
        }
        backView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.equalTo(17)
        }
        backView.addSubview(videoLabel)
        videoLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(commentLabel)
            make.left.equalTo(commentLabel.snp.right)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
