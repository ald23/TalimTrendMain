//
//  CodeConfiramationView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class ConfirmationCodeView: UIView {
    lazy var firstInputView : UITextField = {
        var text = UITextField()
            text.textColor = .grayForText
            text.backgroundColor = .overlayDark
            text.layer.cornerRadius = 8
            text.keyboardType = .numberPad
            text.textAlignment = .center
            text.font = .getSourceSansProRegular(of: 14)
            text.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        return text
    }()
    var onFourthInputViewChange : (()->())?
    
    lazy var secondInputView : UITextField = {
        var text = UITextField()
            text.textColor = .grayForText
            text.backgroundColor = .overlayDark
            text.layer.cornerRadius = 8
            text.keyboardType = .numberPad
            text.textAlignment = .center
            text.font = .getSourceSansProRegular(of: 14)
            text.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        return text
    }()
    lazy var thirdInputView : UITextField = {
        var text = UITextField()
            text.textColor = .grayForText
            text.backgroundColor = .overlayDark
            text.layer.cornerRadius = 8
            text.keyboardType = .numberPad
            text.textAlignment = .center
            text.font = .getSourceSansProRegular(of: 14)
            text.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        return text
    }()
    lazy var fourthInputView : UITextField = {
        var text = UITextField()
            text.textColor = .grayForText
            text.backgroundColor = .overlayDark
            text.layer.cornerRadius = 8
            text.keyboardType = .numberPad
            text.textAlignment = .center
            text.font = .getSourceSansProRegular(of: 14)
            text.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
            text.delegate = self
        
        return text
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupViews()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupViews(){
        addSubview(firstInputView)
            firstInputView.snp.makeConstraints { (make) in
                make.top.left.equalToSuperview()
                make.width.height.equalTo(44)
            }
        addSubview(secondInputView)
            secondInputView.snp.makeConstraints { (make) in
                make.top.width.height.equalTo(firstInputView)
                make.left.equalTo(firstInputView.snp.right).offset(12)
            }
        addSubview(thirdInputView)
            thirdInputView.snp.makeConstraints { (make) in
                make.top.width.height.equalTo(firstInputView)
                make.left.equalTo(secondInputView.snp.right).offset(12)
            }
        addSubview(fourthInputView)
            fourthInputView.snp.makeConstraints { (make) in
                make.top.width.height.equalTo(firstInputView)
                make.left.equalTo(thirdInputView.snp.right).offset(12)
            }
    }
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if text?.count == 1 {
            switch textField {
            case firstInputView:
                secondInputView.becomeFirstResponder()
            case secondInputView:
                thirdInputView.becomeFirstResponder()
            case thirdInputView:
                fourthInputView.becomeFirstResponder()
            case fourthInputView:
                fourthInputView.resignFirstResponder()
            default:
                break
            }
        }
        if text?.count == 0 {
            switch textField {
            case secondInputView:
                firstInputView.becomeFirstResponder()
            case thirdInputView:
                secondInputView.becomeFirstResponder()
            case fourthInputView:
                thirdInputView.becomeFirstResponder()
            default:
                break
            }
        }
    }
    
}


extension ConfirmationCodeView : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onFourthInputViewChange?()
    }
    
}
