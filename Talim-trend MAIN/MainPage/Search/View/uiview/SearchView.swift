//
//  SearchView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class SearchView: UIView {
     //MARK: - properties
    var searchImage : UIImageView = {
        var image = UIImageView()
            image.image = #imageLiteral(resourceName: "search_major_monotone")
            image.contentMode = .left
        
        return image
    }()
    
    var detectChanges : ((String)->())?
    var searchRightPadding : Int = 0{
        didSet{
            constraintsRemaker()
        }
    }

    var searchTextView : UITextField = {
        var textView = UITextField()
            textView.backgroundColor = .overlayDark
            textView.layer.cornerRadius = 20
            textView.textColor = .grayForText
            
        return textView
    }()
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        searchTextView.delegate = self
  
        self.backgroundColor = .overlayDark
        self.layer.cornerRadius = 20
        setupView()
       
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - setup
    func setupView(){
        addSubview(searchImage)
        searchImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(9)
            make.left.equalTo(10)
            make.width.height.equalTo(20)
        }
        addSubview(searchTextView)
        searchTextView.snp.makeConstraints { (make) in
            make.left.equalTo(searchImage.snp.right).offset(3)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(0)
        }
    }
    func constraintsRemaker(){
        UIView.animate(withDuration: 0.2) {
            self.searchTextView.snp.remakeConstraints { (make) in
                make.left.equalTo(self.searchImage.snp.right).offset(3)
                make.top.bottom.equalToSuperview()
                make.right.equalTo(self.searchRightPadding)
            }
        }
    }
    
    
}

extension SearchView : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
       detectChanges?(searchTextView.text!)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchRightPadding = -20
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchRightPadding = 0
    }
}
