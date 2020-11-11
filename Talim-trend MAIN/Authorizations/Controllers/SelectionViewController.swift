//
//  WhoAreYouWatchingWith.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
enum SelectionType {
    case age
    case language
}
class SelectionViewController : LoaderBaseViewController{
    var viewModel = EditProfileViewModel()
    var askLabel : UILabel = {
        var label = UILabel()
            label.text = "Выберите с кем Вы будете смотреть наши видео:"
            label.font = .getSourceSansProSemibold(of: 15)
            label.textColor = .boldTextColor
            label.textAlignment = .center
            label.numberOfLines = 0
        
        return label
    }()
    var selectionType : SelectionType?
    var optionOneView = SelectionView(title: "С детьми")
    var optionTwoView = SelectionView(title: "Без детей")
    var continueButton = BigMainButton(title: "Продолжить", background: .gray)
    var selectedLanguage = ""
    init(question : String, optionOne: String, optionTwo: String, selectionType : SelectionType){
        super.init(nibName: nil, bundle: nil)
        self.selectionType = .language
        self.askLabel.text = question
        optionOneView.titleLabel.text = optionOne
        optionTwoView.titleLabel.text = optionTwo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        dismissSetup()
        setupSelectionAction()
        setupContinuebutton()
        
    }
    func bind(){
        
    }
    func setupSelectionAction(){
        optionOneView.selectionAction = {
            self.selectedLanguage = "Қазақша"
            self.optionTwoView.isselected = false
            self.optionTwoView.circleInside.isselected = false
        }
        optionTwoView.selectionAction = {
            self.selectedLanguage = "Русский"
            self.optionOneView.isselected = false
            self.optionOneView.circleInside.isselected = false
            
        }
    }
    func setupContinuebutton(){
        continueButton.action = {
            if self.selectionType == .language  && self.selectedLanguage != "" {
                if UserManager.getCurrentLang() != self.selectedLanguage{
                    UserManager.setCurrentLang(lang: self.selectedLanguage)
                    self.viewModel.languageChange()
                        AppCenter.shared.start()
                }
                else {
                    self.dismissAction()
                }
            }
            else
            {
                self.navigationController?.pushViewController(CodeConfirmationViewController(), animated: true)
            }
        }
    }
    fileprivate func dismissSetup() {
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        mainView.round(corners: [.topLeft, .topRight], radius: 30)
    }
    func setupViews(){
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
        mainView.addSubview(askLabel)
        askLabel.snp.makeConstraints { (make) in
            make.top.equalTo(14)
            make.left.equalTo(64)
            make.right.equalTo(-64)
        }
        mainView.addSubview(optionOneView)
        optionOneView.snp.makeConstraints { (make) in
            make.top.equalTo(askLabel.snp.bottom).offset(35)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(40)
        }
        mainView.addSubview(optionTwoView)
        optionTwoView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(optionOneView)
            make.top.equalTo(optionOneView.snp.bottom).offset(8)
        }
        mainView.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.top.equalTo(optionTwoView.snp.bottom).offset(32)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
        }
        
        
    }
    
    
    
}
