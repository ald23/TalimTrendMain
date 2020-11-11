//
//  EditProfileViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit


class EditProfileViewController : LoaderBaseViewController {
    
    
    //MARK: - proporties
    var didChangeData = {()->() in }
    var changeProfileImage = ChangeAvatarView()
    var smallNavBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "x"), title: "Редактировать профиль".localized())
    private var inputViewModel = InputViewModel()
    
    private var viewModel = EditProfileViewModel()
    //inputViews
    private var nameInputView = InputView(inputType: .plainText, placeholder: "Ваше имя".localized())
    private var lastNameInputView = InputView(inputType: .plainText, placeholder: "Ваша фамилия".localized())
    private var phoneInputView = InputView(inputType: .phone, placeholder: "Номер телефона".localized())
    private var oldPasswordInputView = InputView(inputType: .secureText, placeholder: "Введите старый пароль".localized(),icon: #imageLiteral(resourceName: "eye"))
    private var newPasswordInputView = InputView(inputType: .secureText, placeholder: "Новый пароль".localized(),icon: #imageLiteral(resourceName: "eye"))
    private var repeatPasswordInputView = InputView(inputType: .secureText, placeholder: "Повторите пароль".localized(),icon: #imageLiteral(resourceName: "eye"))
    private var imagePicker: ImagePicker!
    private var selectedImage : UIImage?
    private var saveButton = BigMainButton(title: "Сохранить".localized(),background: .gray)
    private var savePhoneButton = BigMainButton(title: "Сохранить".localized(),background: .gray)
    private var totalLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProSemibold(of: 12)
            label.textColor = .grayForText
        label.text = "Общая информация".localized()
            
        return label
    }()
    
    private var phoneLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProSemibold(of: 12)
            label.textColor = .grayForText
            label.text = "Телефон"
            
        return label
    }()
    
    private var editParameters = Parameters()
    //MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        viewModel.getProfile()
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
   //     mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        dismissSetup()
        setupAction()
        setupLoaderView()
        bind(to: viewModel)
        setupImagePicker()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.round(corners: [.topLeft,.topRight], radius: 30)
        //neccessary when using gradient background
        saveButton.setupButtonStyle()
    }
    func setupImagePicker(){
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    //MARK: - setup
    fileprivate func dismissSetup() {
        smallNavBar.leftButtonAction = {
             self.dismiss(animated: true)
        }
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }
    private func varified() -> Bool{
        if oldPasswordInputView.textField.text != "" {
            if newPasswordInputView.textField.text == repeatPasswordInputView.textField.text && newPasswordInputView.textField.text != ""
            {
                editParameters["old_password"] = oldPasswordInputView.textField.text
                editParameters["new_password"] = newPasswordInputView.textField.text
                editParameters["new_password_confirmation"] = repeatPasswordInputView.textField.text
                return true
            }
            else {
                showErrorMessage("Введите новый пароль")
                return false
            }
        }
        if (newPasswordInputView.textField.text != "" || repeatPasswordInputView.textField.text != "") && oldPasswordInputView.textField.text == ""{
            showErrorMessage("Введите старый пароль")
            return false
        }
        if nameInputView.textField.text != ""{
            editParameters["first_name"] = nameInputView.textField.text
        }
        if lastNameInputView.textField.text != ""{
            editParameters["last_name"] = lastNameInputView.textField.text
        }
        if  let phone = phoneInputView.phoneTextField.text, inputViewModel.setPhone(phone) {
            editParameters["phone"] = inputViewModel.phone
        }
        if selectedImage != nil{
            editParameters["avatar"] = selectedImage?.jpegData(compressionQuality: 0.2)
        }
        return true
       
    }
    private func setupAction(){
        saveButton.action = { [weak self] in
            guard  let `self` = self else { return }
            guard self.varified() else {return }
            self.viewModel.editProfile(params: self.editParameters)
        }
        changeProfileImage.changeAvatarAction = {
            self.imagePicker.present(from: UIButton())
        }
        savePhoneButton.action = {
            if  let phone = self.phoneInputView.phoneTextField.text, self.inputViewModel.setPhone(phone) {
                
                self.viewModel.changePhoneNumber(phone: self.inputViewModel.phone)
            }
        }
    }
    
    private func bind(to viewModel: EditProfileViewModel) {
        viewModel.error.observe(on: self) { [weak self] in
        guard  let `self` = self else { return }
        self.showAlert(type: .error, $0)}
    
        viewModel.loading.observe(on: self) { loading in
        if (loading) {
            LoaderView.show()
        } else {
            self.view.isHidden = false
            LoaderView.hide()
        }
        }
        viewModel.message.observe(on: self) { (message) in
            if message != ""{
                self.dismissAction()
                self.didChangeData()
            }
        }
        viewModel.profileInfo.observe(on: self) { (user) in
            if user != nil
           { self.setupDefaultData(with: user!)}
        }
        viewModel.phone.observe(on: self) { [self] (message) in
            if message != "" {
            let vc = CodeConfirmationViewController()
                self.inputViewModel.setPhone(phoneInputView.phoneTextField.text!)
                vc.newPhone = self.inputViewModel.phone
                    
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
       
        
    }
    
    func setupDefaultData(with user: User){
        changeProfileImage.profileImageView.sd_setImage(with: user.avatar?.serverUrlString.url, completed: nil)
        nameInputView.textField.text = user.first_name
        lastNameInputView.textField.text = user.last_name
    }
    private func setupView(){
        
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(800)
        }
        
        addSubview(viewOnTopOfMainForDismissing)
           viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
               make.top.left.right.equalTo(0)
               make.bottom.equalTo(mainView.snp.top)
        }
        
        mainView.addSubview(smallNavBar)
        smallNavBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(AppConstants.smallNavBarHeight)
        }
        
        mainView.addSubview(changeProfileImage)
        changeProfileImage.snp.makeConstraints { (make) in
            make.top.equalTo(smallNavBar.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        mainView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(changeProfileImage.snp.bottom).offset(4)
            make.left.equalTo(20)
        }
        mainView.addSubview(nameInputView)
        nameInputView.snp.makeConstraints { (make) in
            make.top.equalTo(changeProfileImage.snp.bottom).offset(25)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        mainView.addSubview(lastNameInputView)
        lastNameInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameInputView)
            make.top.equalTo(nameInputView.snp.bottom).offset(10)
        }
        
  
        mainView.addSubview(oldPasswordInputView)
            oldPasswordInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameInputView)
            make.top.equalTo(lastNameInputView.snp.bottom).offset(8)
        }
        mainView.addSubview(newPasswordInputView)
            newPasswordInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameInputView)
            make.top.equalTo(oldPasswordInputView.snp.bottom).offset(8)
        }
        mainView.addSubview(repeatPasswordInputView)
        repeatPasswordInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameInputView)
            make.top.equalTo(newPasswordInputView.snp.bottom).offset(8)
        }
        mainView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(repeatPasswordInputView.snp.bottom).offset(18)
            make.left.right.equalTo(newPasswordInputView)
            make.height.equalTo(50)
        }
        mainView.addSubview(phoneLabel)
        phoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(saveButton.snp.bottom).offset(10)
            make.left.equalTo(20)
        }
        mainView.addSubview(phoneInputView)
        phoneInputView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameInputView)
            make.top.equalTo(saveButton.snp.bottom).offset(35)
        }
        mainView.addSubview(savePhoneButton)
        savePhoneButton.snp.makeConstraints { (make) in
            make.top.equalTo(phoneInputView.snp.bottom).offset(8)
            make.left.right.height.equalTo(saveButton)
        }
 
    }
 
}

extension EditProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.changeProfileImage.profileImageView.image = image
        self.selectedImage = image
    }
}


