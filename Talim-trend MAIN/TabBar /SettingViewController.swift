//
//  SettingViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
enum SettingsType {
    case player
    case shareButton
}
class SettingViewController: LoaderBaseViewController {
    var playSpeedViewController = PlayRateViewConroller()
    var shareLink = ""
    var inFavorite = false
    var id = 0
    var didChangeFavorites = {()->() in}
    var viewModel = PlayerViewModel()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    var type : SettingsType!
    
    init(type : SettingsType){
        super.init(nibName: nil, bundle: nil)
        self.type = type
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        setupViewForShare()
    }
    var speedButton = BigMainButton(title: "Отмена".localized(), background: .gray)
    var qualityButton = BigMainButton(title: "Скорость возпроизведения".localized(), background: .gray)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.round(corners: [.topLeft, .topRight], radius: 20)
        
    }
    func setupAction(){
        viewOnTopOfMainForDismissing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAction)))
        if self.type == .player {
        qualityButton.action = {
            self.navigationController?.pushViewController(self.playSpeedViewController, animated: true)
        }
        speedButton.action = {
            self.dismissAction()
        }
        }
        else {
           speedButton.action = {
            let items = [self.shareLink.url]
            self.present(UIActivityViewController(activityItems: items, applicationActivities: nil),animated: true)
            }
            qualityButton.action = {
                if self.type != .player {
                guard UserManager.isAuthorized() else {
                    let vc = WelcomeBackViewController().inNavigation()
                        vc.modalPresentationStyle = .overFullScreen
                    
                    self.present(vc,animated: true)
                    return
                }
                }
                self.viewModel.addToFavorites(id: self.id)
                self.inFavorite.toggle()
                
                self.didChangeFavorites()
                
                if self.inFavorite {
                    self.qualityButton.setTitle("Удалить из избранного".localized(), for: .normal)
                }
                else {
                    self.qualityButton.setTitle("Добавить в избранное".localized(), for: .normal)
                }
            }
        }
        
    }
    func setupViewForShare(){
        if type == .shareButton{
            speedButton.setTitle("Поделиться".localized(), for: .normal)
            if inFavorite {
                qualityButton.setTitle("Удалить из избранного".localized(), for: .normal)
            }
            else {
                qualityButton.setTitle("Добавить в избранное".localized(), for: .normal)
            }
        }
    }
    func setupView(){
        addSubview(mainView)
        addSubview(viewOnTopOfMainForDismissing)
        mainView.snp.makeConstraints { (make) in
            make.height.equalTo(AppConstants.screenHeight/5)
            make.left.right.bottom.equalToSuperview()
        }
        viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
            make.bottom.equalTo(mainView.snp.top)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        mainView.addSubview(qualityButton)
        qualityButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(20)
        }
        mainView.addSubview(speedButton)
        speedButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(18)
            make.right.equalTo(-18)
            make.top.equalTo(qualityButton.snp.bottom).offset(10)
        }
       
    }
}
