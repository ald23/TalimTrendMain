//
//  InputView.swift
//  VideoHosting
//
//  Created by Eldor Makkambayev on 12/19/19.
//  Copyright © 2019 Eldor Makkambayev. All rights reserved.
//

import UIKit
enum InputTypes {
    case phone
    case plainText
    case secureText
    
    var isSecure: Bool {
        return .secureText == self
    }
}

enum InputViewTypes {
    case email
    case phone
    case iin
    case `default`
}


class InputView: UIView {
    
    //MARK: - Properties
    let inputType: InputTypes
    var placeholder: String
    private let icon: UIImage?
    var iconAction: (() -> ())?

    
    lazy var textField: UITextField = {
        let tf = UITextField()
            tf.layer.cornerRadius = 10
            tf.clipsToBounds = true
            tf.tag = 0
            tf.isSecureTextEntry = inputType.isSecure
            tf.borderStyle = .none
            tf.font = .getSourceSansProRegular(of: 13)
            tf.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            tf.backgroundColor = .overlayDark
            tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                          attributes: [
                                                            NSAttributedString.Key.foregroundColor:  UIColor.grayForText,
                                                            NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 14)])
            //margin left
            tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            tf.leftViewMode = .always

        return tf
    }()
    
    lazy var phoneTextField: PhoneTextField = {
        let tf = PhoneTextField()
            tf.tag = 1
            tf.borderStyle = .none
            tf.font = .getSourceSansProRegular(of: 13)
            tf.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
            tf.backgroundColor = .overlayDark
            tf.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                      attributes: [
                                                        NSAttributedString.Key.foregroundColor: UIColor.grayForText,
                                                        NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 14)])
            //margin left
             tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
             tf.leftViewMode = .always
        
        return tf
    }()
    
    lazy var iconView: UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            iv.image = icon
            iv.isUserInteractionEnabled = true
        
        return iv
    }()


    //MARK: - Initialization
    init(inputType: InputTypes, placeholder: String, icon: UIImage? = nil) {
        self.inputType = inputType
        self.placeholder = placeholder
        self.icon = icon
        super.init(frame: .zero)
        
        setupViews()
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup functions
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func setupViews() {

        self.layer.cornerRadius = 8
        
        if inputType == .phone {
            self.addSubview(self.phoneTextField)
            self.phoneTextField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        } else {
            self.addSubview(self.textField)
            self.textField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
            addSubview(iconView)
            iconView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-10)
                make.height.width.equalTo(23)
            }

    }
    
    private func setupGesture() -> Void {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTarget))
        iconView.addGestureRecognizer(tapGesture)
        
    }
    @objc func iconTarget() -> Void {
        iconAction?()
    }


}
