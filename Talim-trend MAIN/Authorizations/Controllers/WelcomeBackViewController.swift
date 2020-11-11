//
//  WelcomeBackViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class WelcomeBackViewController : LoaderBaseViewController {
    
    private var viewModel = AuthorizationViewModel()
    private var inputViewModel = InputViewModel()
    
    private var smallNavBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "x"), title: "С возвращением!".localized())
    private var phoneInputView = InputView(inputType: .phone, placeholder: "")
    private var passwordInputView = InputView(inputType: .secureText, placeholder: "Введите пароль".localized(),icon: #imageLiteral(resourceName: "eye"))
    private var confiramationCircle = SelectionCircleWithImage()
    private var rememberInfoLabel : UILabel  = {
        var label = UILabel()
        label.text = "Запомнить данные".localized()
        label.font = .getSourceSansProRegular(of: 12)
        label.textColor = .grayForText
        
        return label
    }()
    private var forgotPasswordButton : UIButton = {
        var button = UIButton()
        button.setTitle("Забыли пароль?".localized(), for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1), for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .getSourceSansProRegular(of: 12)
        
        return button
    }()
    private var loginButton = BigMainButton(title: "Вход".localized(), background: .gradient)
    private var noAccountLabel : UILabel = {
        var label = UILabel()
        label.text = "Нет аккаунта?".localized()
        label.font = .getSourceSansProRegular(of: 15)
        label.textColor = .grayForText
        
        return label
    }()
    private var noAccountButton : UIButton = {
        var button = UIButton()
        button.setTitle("Создайте сейчас".localized(), for: .normal)
            button.setTitleColor(#colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1), for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = .getSourceSansProRegular(of: 15)
        
        return button
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        dismissSetup()
        setupAction()
        
        bind(to: viewModel)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        loginButton.setupButtonStyle()
        
    }
    
    private func bind(to viewModel: AuthorizationViewModel) {
        viewModel.error.observe(on: self) { [weak self] message in
            guard  let `self` = self else { return }
            if message != ""{
            self.showAlert(type: .error, message)}
        }
        viewModel.loading.observe(on: self) { loading in
            if (loading) {
                LoaderView.show()
            } else {
                self.view.isHidden = false
                LoaderView.hide()
            }
        }
        viewModel.localLanguage.observe(on: self) { lang in
            if lang != "" {
                UserManager.setCurrentLang(lang: viewModel.localLanguage.value)
            }
        }
        viewModel.token.observe(on: self) { token in
            if token != "" {
                UserManager.setCurrentToken(to: viewModel.token.value)
                self.dismiss(animated: true) {
                    AppCenter.shared.start()
                }
            }
        }
     
        
    }

    private func setupAction(){
     
        noAccountButton.addTarget(self, action: #selector(toRegPage), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        
        passwordInputView.iconAction = { [weak self] in
            guard let `self` = self else { return }
            self.passwordInputView.textField.isSecureTextEntry.toggle()
        }
    }
    @objc func forgotPasswordAction(){
        self.navigationController?.pushViewController(PhoneInputViewController(type: .phone), animated: true)
    }
    
    fileprivate func dismissSetup() {
        
        smallNavBar.leftButtonAction = { [weak self] in
            guard let `self` = self else { return }
            self.dismiss(animated: true)
        }
        
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }
    
    
    private func setupView(){
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
//            make.height.equalTo(345)
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
        
        mainView.addSubview(phoneInputView)
        phoneInputView.snp.makeConstraints { (make) in
            make.top.equalTo(smallNavBar.snp.bottom).offset(30)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(40)
        }
        
        mainView.addSubview(passwordInputView)
        passwordInputView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneInputView.snp.bottom).offset(10)
            make.left.right.height.equalTo(phoneInputView)
        }
        
        mainView.addSubview(confiramationCircle)
        confiramationCircle.snp.makeConstraints { (make) in
            make.left.equalTo(passwordInputView).offset(3)
            make.top.equalTo(passwordInputView.snp.bottom).offset(6)
            make.width.height.equalTo(16)
        }
        
        mainView.addSubview(rememberInfoLabel)
        rememberInfoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confiramationCircle).offset(1)
            make.left.equalTo(confiramationCircle.snp.right).offset(3)
        }
        
        mainView.addSubview(forgotPasswordButton)
        forgotPasswordButton.snp.makeConstraints { (make) in
            make.top.equalTo(rememberInfoLabel)
            make.right.equalTo(-17)
            make.width.equalTo(90)
            make.height.equalTo(17)
        }
        
        mainView.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(40)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
        }
        mainView.addSubview(noAccountLabel)
        noAccountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButton.snp.bottom).offset(15)
            make.left.equalTo(90)
        }
        mainView.addSubview(noAccountButton)
        noAccountButton.snp.makeConstraints { (make) in
            make.left.equalTo(noAccountLabel.snp.right).offset(10)
            make.top.equalTo(noAccountLabel).offset(-6)
            make.bottom.equalTo(-32)
        }
        
    }
    
    private func verified() -> Bool {
        guard let phone = phoneInputView.phoneTextField.text, inputViewModel.setPhone(phone) else {
            
            self.showAlert(type: .error, inputViewModel.errorMessage)
            return false }
        guard let passwrd = passwordInputView.textField.text, passwrd.count > 3 else {
            self.showAlert(type: .error, "Неправильный формат пароля".localized())
            return false }
        
        return true
    }
    
    @objc func toRegPage() {
        self.navigationController?.pushViewController(WelcomePageViewController(), animated: true)
    }
    
    @objc func loginButtonAction() {
        guard verified() else { return }
        
        let parameters: Parameters = ["phone" : inputViewModel.phone,
                                      "password": passwordInputView.textField.text!,
                                    ]
        
        viewModel.getLogin(params: parameters)
    }
}
