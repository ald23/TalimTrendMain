//
//  LeaveCommentView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/26/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class LeaveCommentView : UIView {
    var userAvatarImageView : UIImageView = {
        var image = UIImageView()
            image.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
            image.layer.cornerRadius = 20
        
        return image
    }()
    var didPressReturnButton : ((String)->())?
    
//    var commentTextField : UITextField = {
//        var textField = UITextField()
//            textField.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
//            textField.layer.cornerRadius = 20
//            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 0))
//            textField.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
//            textField.leftViewMode = .always
//
//
//        return textField
//    }()
    var commentTextField =  InputView(inputType: .plainText, placeholder: "")
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
        commentTextField.textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        self.backgroundColor = .clear
        addSubview(userAvatarImageView)
        userAvatarImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(40)
            make.top.left.bottom.equalToSuperview()
        }
        addSubview(commentTextField)
        commentTextField.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(userAvatarImageView.snp.right).offset(10)
        }
    }
    
}
extension LeaveCommentView : UITextFieldDelegate{
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didPressReturnButton?(textField.text!)
        textField.text = ""
        textField.resignFirstResponder()
        return true
        
    }
}
