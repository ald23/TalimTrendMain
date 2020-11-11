//
//  PhoneTextField.swift
//  VideoLessons
//
//  Created by Eldor Makkambayev on 2/12/20.
//  Copyright © 2020 Eldor Makkambayev. All rights reserved.
//

import Foundation
import UIKit
class PhoneTextField: UITextField {
    
    //MARK:- Preasure
    
    var didBeginEditing: (() -> ())?
    var didEndEditing: (() -> ())?
    
    fileprivate var label: UILabel = {
        let label = UILabel()
        label.text = ""
        
        return label
    }()
    
    //MARK:- Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- SetupViews
    func setupViews() -> Void {
        layer.cornerRadius = 10
        
        leftView = label
        leftViewMode = .always
        rightViewMode = .always
        font = UIFont.boldSystemFont(ofSize: 15)
        text = "+7"
        delegate = self
        keyboardType = .decimalPad
    }
    
}
//MARK:- UITextFieldDelegate
extension PhoneTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = textField.text!
        let spaceIndex = [2, 6, 10, 13]

        if text == "+7" && string == "" {
            return false
        }

        if text.count == 16 && string != "" {
            return false
        }

        if spaceIndex.contains(textField.text!.count) && string != "" {
            textField.text!.append(" ")
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?()
    }
}
