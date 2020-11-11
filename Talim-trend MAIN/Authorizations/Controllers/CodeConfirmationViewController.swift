//
//  CodeConfirmationViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
class CodeConfirmationViewController : LoaderBaseViewController {
    
    var newPhone = ""
    private var smallNavBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "back"), title: "Подтверждение кода доступа")
    private var confirmationLabel : UILabel = {
        var label = UILabel()
            label.text = "Мы отправили код подтверждения на ваш номер:"
            label.textColor = .grayForText
            label.font = .getSourceSansProRegular(of: 14)
            label.numberOfLines = 0
            label.textAlignment = .center
        
        return label
    }()
    var viewModel = AuthorizationViewModel()
    var parameters = Parameters()
    private var phoneNumberLabel : UILabel = {
        var label = UILabel()
            label.textAlignment = .center
            label.textColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            label.text = " +7 702-517-11-98"
            label.font = .getSourceSansProRegular(of: 17)
            label.numberOfLines = 0
        
        return label
    }()
    private var enterCodeLabel : UILabel = {
        var label = UILabel()
            label.text = "Введите его сюда:"
            label.textAlignment = .center
            label.textColor = .grayForText
            label.font = .getSourceSansProRegular(of: 12)
            
        return label
    }()
    private var confirmationView =  ConfirmationCodeView()
    private var mainButton = BigMainButton(title: "Продолжить".localized(), background: .gray)
    var phone = ""
    var timerLabel : UILabel = {
        var label = UILabel()
            label.textAlignment = .center
            label.textColor = .grayForText
            label.font = .getSourceSansProRegular(of: 12)
            label.text = "60 секунд осталось"
            label.isUserInteractionEnabled = false
        
        return label
    }()
    var secondsLeft = 60
   
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(true)
         mainView.round(corners: [.topLeft, .topRight], radius: 30)
     }

    fileprivate func binder() {
        viewModel.token.observe(on: self)  { [unowned self] (token) in
            if token != "" {
                UserManager.setCurrentToken(to: token)
                if self.phone == ""{
                    self.navigationController?.pushViewController(SuccessViewController(), animated: true)
                }
                else {
                    let vc = PhoneInputViewController(type: .password)
                    vc.phone = phone
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        viewModel.message.observe(on: self) { (message) in
            if self.newPhone == "" {
            if message != ""{
                let vc = PhoneInputViewController(type: .password)
                vc.phone = self.phone
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }
            else {
                if message != "" {
                self.navigationController?.pushViewController(SuccessViewController(), animated: true)
                }
            }
        }
        viewModel.error.observe(on: self) { (error) in
            if error != ""{
            self.showErrorMessage(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dismissSetup()
        setupAction()
        mainButtonSetup()
        confirmationViewSetup()
        setupLoaderView()
        binder()
        timerSetup()
   
    }
    func timerSetup(){
         Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if self.secondsLeft > 0 {
                self.secondsLeft -= 1
                self.timerLabel.text = "\(self.secondsLeft) секунд осталось"
                self.timerLabel.textColor = .grayForText
            }
            else {
                self.timerLabel.text = "отправить снова"
                self.timerLabel.textColor = .mainColor
                self.timerLabel.isUserInteractionEnabled = true
                timer.invalidate()
            }
        }
    }
    
    private func confirmationViewSetup(){
        confirmationView.onFourthInputViewChange = {
            self.toNextViewController()
          }
    }
    
    private func mainButtonSetup(){
        mainButton.action = { [weak self] in
            
            self?.toNextViewController()
        }
    }
    private func toNextViewController(){
        guard let codeOne = confirmationView.firstInputView.text, let codeTwo = confirmationView.secondInputView.text, let codeThree = confirmationView.thirdInputView.text, let codeFour = confirmationView.fourthInputView.text else {
            return
        }
        parameters["code"] = codeOne + codeTwo + codeThree + codeFour
     
        if newPhone != ""{
            parameters["newPhone"] = newPhone
            viewModel.changePhone(params : parameters)
        }
        else if phone != ""{
            parameters["phone"] = phone
            viewModel.varifyCode(parameters: parameters)
        }
        else {
            viewModel.getCodeConfirmation(parameters: parameters)
        }
        
}
    fileprivate func dismissSetup() {
  
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }

    private func setupAction(){
        smallNavBar.leftButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        timerLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTimeLabel)))
    }
    @objc func didTapTimeLabel(){
        self.parameters.removeValue(forKey: "code")
        if phone == ""{
            self.viewModel.getRegistration(params: parameters)
        }
        else {
            viewModel.forgotPassword(phone: phone)
        }
        self.timerLabel.isUserInteractionEnabled = false
        secondsLeft = 60
        timerSetup()
        
    }
    
    private func setupViews(){
        phoneNumberLabel.text = parameters["phone"] as? String
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.bottom.right.left.equalToSuperview()
            make.height.equalTo(300)
            
        }
        view.addSubview(viewOnTopOfMainForDismissing)
        viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainView.snp.top)
            make.left.right.top.equalToSuperview()
        }
        mainView.addSubview(smallNavBar)
           smallNavBar.snp.makeConstraints { (make) in
               make.top.left.right.equalTo(0)
               make.height.equalTo(AppConstants.smallNavBarHeight)
        }
        mainView.addSubview(confirmationLabel)
        confirmationLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(smallNavBar.snp.bottom).offset(17)
        }
        mainView.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confirmationLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        mainView.addSubview(enterCodeLabel)
        enterCodeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        mainView.addSubview(confirmationView)
        confirmationView.snp.makeConstraints { (make) in
            make.top.equalTo(enterCodeLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            make.width.equalTo(205)
            make.height.equalTo(44)
        }
        mainView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(confirmationView.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        mainView.addSubview(mainButton)
        mainButton.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
            make.top.equalTo(confirmationView.snp.bottom).offset(33)
            
        }
    }
    
    @objc func  pushViewController(){
        self.navigationController?.pushViewController(SuccessViewController(), animated: true)
    }

}
 
