//
//  PhoneInputViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 10/8/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
enum ChangeType {
    case phone
    case password
}
class PhoneInputViewController: LoaderBaseViewController {
    var phoneInputView = InputView(inputType: .phone, placeholder: "")
    let input = InputViewModel()
    var passwordInputView = InputView(inputType: .secureText , placeholder: "Новый пароль".localized())
    var currentInput : InputView!
    var smallNavBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "back"), title: "Введите номер".localized())
    var mainButton = BigMainButton(title: "Далее".localized(), background: .gray)
    var phone = ""
    private var inputViewModel = InputViewModel()
    var viewModel = AuthorizationViewModel()
    var type : ChangeType = .phone
    
    init(type : ChangeType) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        binder()
        if type == .password {
            smallNavBar.navBarTitle.text = "Новый пароль".localized()
        }
    }
    
    func binder(){
        self.viewModel.id.observe(on: self) { (id) in
            if id != -1 {
                let vc = CodeConfirmationViewController()
                self.input.setPhone(self.phoneInputView.phoneTextField.text!)
                vc.phone = self.input.phone
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        viewModel.token.observe(on: self) { (token) in
            if token != "" {
                UserManager.setCurrentToken(to: token)
                self.navigationController?.pushViewController(SuccessViewController(), animated: true)
            }
        }
    }
    func setupAction(){
        smallNavBar.leftButtonAction = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.navigationController?.popViewController(animated: true)
        }
        mainButton.action = { [weak self] in
            guard let strongSelf = self else {return}
            if strongSelf.type == .phone {
            guard let text =  strongSelf.phoneInputView.phoneTextField.text else {
                strongSelf.showErrorMessage("Номер телефона")
            return
            }
            guard strongSelf.inputViewModel.setPhone(text) else {
                strongSelf.showErrorMessage("Неверный формат телефона")
                return
            }
            strongSelf.viewModel.forgotPassword(phone: strongSelf.inputViewModel.phone)
            }
            else {
           
                strongSelf.viewModel.restorePassword(newPassword: strongSelf.passwordInputView.textField.text!,phone : strongSelf.phone)
                
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.round(corners: [.topLeft,.topRight], radius: 20)
    }
    func setupView(){
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        addSubview(viewOnTopOfMainForDismissing)
        viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainView.snp.top)
            make.left.right.top.equalToSuperview()
        }
        mainView.addSubview(smallNavBar)
        smallNavBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(AppConstants.smallNavBarHeight)
            make.left.right.equalToSuperview()
        }
        if type == .password {
            currentInput = passwordInputView
        }
        else {
            currentInput = phoneInputView
        }
        mainView.addSubview(currentInput)
        
        currentInput.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(40)
            make.top.equalTo(smallNavBar.snp.bottom).offset(30)
        }
        mainView.addSubview(mainButton)
        mainButton.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
            make.top.equalTo(currentInput.snp.bottom).offset(10)
        }
    }
}
