//
//  WelcomePageViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class WelcomePageViewController: LoaderBaseViewController {
    
    private var viewModel = AuthorizationViewModel()
    private var inputViewModel = InputViewModel()

    private var smallNavBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "x"), title: "Добро пожаловать!".localized())
    var parameters = Parameters()
    private var nameInputView = InputView(inputType: .plainText, placeholder: "Ваше имя".localized())
    private var lastNameInputView = InputView(inputType: .plainText, placeholder: "Ваша фамилия".localized())
    private var phoneInputView = InputView(inputType: .phone, placeholder: "")
    private var passwordInputView = InputView(inputType: .secureText, placeholder: "Введите пароль".localized())
    private var registerButton = BigMainButton(title: "Зарегистрироваться".localized(), background: .gradient)
    private var circleSelection = SelectionCircleWithImage()
    private var policyLabel: UILabel = {
        
        let firstAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.grayForText.cgColor, NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 13)]
        let secondAttributes : [NSAttributedString.Key : Any] =  [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1),NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 13)]
        
        let firstString = NSMutableAttributedString(string: "Вы согласны ", attributes: firstAttributes)
        let secondString = NSAttributedString(string: "с условиями использования", attributes: secondAttributes)
        let thirdString = NSMutableAttributedString(string: " и ", attributes: firstAttributes)
        let fourthString = NSAttributedString(string: " политики конфиденциальности?", attributes: secondAttributes)
        let fifthString = NSAttributedString(string: "?", attributes: firstAttributes)
        
        firstString.append(secondString)
        firstString.append(thirdString)
        firstString.append(fourthString)
        firstString.append(fifthString)
        
        let label = UILabel()
        label.attributedText = firstString
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        dismissSetup()
        setupActions()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        registerButton.setupButtonStyle()
    }
    
    fileprivate func dismissSetup() {
        smallNavBar.leftButtonAction = {
            self.dismiss(animated: true)
        }
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }
    
    private func bind(to viewModel: AuthorizationViewModel) {
        viewModel.error.observe(on: self) { [weak self] result in
            guard  let `self` = self else { return }
            if result != "" {
            self.showAlert(type: .error, result)}
        }
        viewModel.loading.observe(on: self) { loading in
            if (loading) {
                LoaderView.show()
            } else {
                self.view.isHidden = false
                LoaderView.hide()
            }
        }
   
        viewModel.id.observe(on: self){ id in
            if id != -1{
                let vc = CodeConfirmationViewController()
                vc.parameters = self.parameters
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }

    private func setupView(){
        
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(425)
        }
        addSubview(viewOnTopOfMainForDismissing)
        viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(mainView.snp.top)
        }
        mainView.addSubview(smallNavBar)
        smallNavBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(AppConstants.smallNavBarHeight)
        }
        
        mainView.addSubview(nameInputView)
        nameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(smallNavBar.snp.bottom).offset(30)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(40)
        }
        mainView.addSubview(lastNameInputView)
        lastNameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(nameInputView.snp.bottom).offset(10)
            make.left.right.height.equalTo(nameInputView)
        }
        
        mainView.addSubview(phoneInputView)
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(lastNameInputView.snp.bottom).offset(10)
            make.left.right.height.equalTo(nameInputView)
        }
        
        
        mainView.addSubview(passwordInputView)
        passwordInputView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneInputView.snp.bottom).offset(10)
            make.left.right.height.equalTo(nameInputView)
        }
        mainView.addSubview(circleSelection)
        circleSelection.snp.makeConstraints { (make) in
            make.top.equalTo(passwordInputView.snp.bottom).offset(15)
            make.width.height.equalTo(16)
            make.left.equalTo(passwordInputView)
        }
        mainView.addSubview(policyLabel)
        policyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(circleSelection.snp.right).offset(3)
            make.top.equalTo(circleSelection)
            make.right.equalTo(-17)
        }
        mainView.addSubview(registerButton)
        registerButton.snp.makeConstraints { (make) in
            make.top.equalTo(policyLabel.snp.bottom).offset(40)
            make.left.right.equalTo(passwordInputView)
            make.height.equalTo(50)
        }
    }
    
    private func setupActions() {
        registerButton.addTarget(self, action: #selector(registrationButtonAction), for: .touchUpInside)
    }
    
    private func verified() -> Bool {
   
        guard inputViewModel.setUserInfo(nameInputView.textField.text!) else { self.showAlert(type: .error, inputViewModel.errorMessage)
            return false
        }

        guard inputViewModel.setUserInfo(lastNameInputView.textField.text!) else { self.showAlert(type: .error, inputViewModel.errorMessage)
            return false
        }

        guard let phone = phoneInputView.phoneTextField.text, inputViewModel.setPhone(phone) else {
            
            self.showAlert(type: .error, inputViewModel.errorMessage)
            return false }
        guard let passwrd = passwordInputView.textField.text, passwrd.count > 3 else {
            self.showAlert(type: .error, "Неправильный формат пароля")
            return false }
        guard circleSelection.isselected else {
            self.showAlert(type: .error, "Нам необходимо ваше согласие на политику конфиденциальности")
            return false
        }
        
        return true
    }

    
    @objc func registrationButtonAction() {
        guard verified() else { return }
        
        parameters = ["first_name": nameInputView.textField.text!,
                                      "last_name": lastNameInputView.textField.text!,
                                      "phone" : inputViewModel.phone,
                                      "password": passwordInputView.textField.text!
        ]
        
        viewModel.getRegistration(params: parameters)
    }

}
