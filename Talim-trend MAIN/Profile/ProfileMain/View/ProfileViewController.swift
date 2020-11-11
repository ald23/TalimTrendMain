//
//  File.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
class ProfileViewController : LoaderBaseViewController {
    var navBar = NavigationBarView(title: "Профиль", rightButtonImage: #imageLiteral(resourceName: "edit"))
    var viewModel = ProfileViewModel()
    private var profileView = ProfileView()
    private var tableView = UITableView()
    var editProfileVC = EditProfileViewController()
    private var tableViewFooterView: UIView = {
        var view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        
        return view
    }()
    var hasNotifications = false {
        didSet {
            tableView.reloadData()
        }
    }
    private var changeProfileButton = BigMainButton(title: "Сменить аккаунт".localized(), background: .gray)
    private var recentlyWatchedView = RecentlyWatchedView(type: .recentlyWatced)
    private var settingsLabel: UILabel = {
        var label = UILabel()
            label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
        
        return label
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewModelMethods()
        setupGuestView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         setupGradient()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupView()
        setupTableView()
        setupNavBarAction()
        bind()
        setupAction()
        setupLoaderView()
     
    }
    fileprivate func viewModelMethods() {
        viewModel.getProfile()
        
    }
    private func setupAction(){
        editProfileVC.didChangeData = {
            self.viewModelMethods()
        }
        recentlyWatchedView.didSelectVideoAction = { id in
            (self.tabBarController as! TabBarViewController).setVideoId(id: id, controller: self)
        }
        let vc = WelcomeBackViewController()
        vc.mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        vc.modalPresentationStyle = .overFullScreen
       
        
        changeProfileButton.action = {
            if UserManager.isAuthorized(){
            UserManager.deleteCurrentSession()
                AppCenter.shared.start()
            }
            else {
                vc.modalPresentationStyle = .overFullScreen
                self.navigationController?.present(vc.inNavigation(),animated: true)
            }
        }
    }
    func setupGradient(){
        changeProfileButton.background = !UserManager.isAuthorized() ? .gradient : .gray
        changeProfileButton.setupButtonStyle()
    }
    private func bind(){
        if UserManager.isAuthorized(){
            viewModel.error.observe(on: self) { [weak self] in
                guard  let `self` = self else { return }
                self.showAlert(type: .error, $0)}
            
            viewModel.loading.observe(on: self) { loading in
                if (loading) {
                    LoaderView.show()
                } else {
                    LoaderView.hide()
                }
            }
            viewModel.profileInfo.observe(on: self, observerBlock: { (user) in
                if user != nil{
                self.setupUser(with: user!)
                    
                }
            })

        }
    }
    
    private func setupUser(with user: User){
        recentlyWatchedView.viewModel.getRecentylyWatched(page: 1)
        recentlyWatchedView.collectionView.reloadData()
        hasNotifications = user.notification == 1 ? true : false
        profileView.profileName.text = user.first_name + " " +  user.last_name
        profileView.profileImage.load(url: (user.avatar ?? "").serverUrlString.url)
        
    }
    func setupGuestView(){
        recentlyWatchedView.isHidden = !UserManager.isAuthorized()
        !UserManager.isAuthorized() ? changeProfileButton.setTitle("Вход или регистрация".localized(), for: .normal) : changeProfileButton.setTitle("Сменить аккаунт".localized(), for: .normal)
    }
    
    private func setupNavBarAction(){

        navBar.rightButtonTarget = {[weak self] in
            guard let `self` = self else { return }
            guard UserManager.isAuthorized() else  {
                let vc = WelcomeBackViewController().inNavigation()
                    vc.modalPresentationStyle = .overFullScreen
                
                self.navigationController?.present(vc,animated: true)
                return
            }
            

            
            self.editProfileVC.modalPresentationStyle = .overFullScreen
            //self.editProfileVC.navigationBar.isHidden = true

            self.present(self.editProfileVC.inNavigation(),animated: true)
        }
        
        navBar.rightButtonNeighborAction = { [weak self] in
            guard let `self` = self else { return }
            guard UserManager.isAuthorized() else  {
                let vc = WelcomeBackViewController().inNavigation()
                    vc.modalPresentationStyle = .overFullScreen
                
                self.navigationController?.present(vc,animated: true)
                return
            }
            let donateVC = UINavigationController(rootViewController: DonationViewController())
                donateVC.modalPresentationStyle = .overFullScreen
                donateVC.navigationBar.isHidden = true
                
            self.present(donateVC,animated: true)
        }
    }
    
    private func setupTableView(){
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.cellIdentifier())
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.isScrollEnabled = false
    }
    
    private func setupView(){
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)

        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.navBarHeight)
            
        }
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(70)
            make.top.equalTo(60)
        }
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(profileView.snp.bottom).offset(40)
            make.left.right.equalTo(profileView)
            make.height.equalTo(340)
        }
        contentView.addSubview(recentlyWatchedView)
        recentlyWatchedView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.left.equalTo(17)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(-AppConstants.getTabbarHeight(tabBarController) - 44)
        }
        view.addSubview(changeProfileButton)
        changeProfileButton.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
            make.bottom.equalTo(-AppConstants.getTabbarHeight(tabBarController) - 19)
        }
    }
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 2 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.cellIdentifier(), for: indexPath) as! SettingsCell
            cell.selectionStyle = .none
            cell.setupValues(section: indexPath.section, row: indexPath.row)
            cell.notificationsSwitch.isOn = hasNotifications
            cell.notificationsSwitch.setupUI()
            cell.didFailToLogin = {
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.present(vc,animated: true)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 20
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        tableViewFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        35
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        settingsLabel.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        
        if section == 0 {
            let settingsLabel : UILabel = {
                let label = UILabel()
                    label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
                label.text = "Настройки".localized()
                
                return label
            }()
            
            return settingsLabel
        }
        else {
            let settingsLabel : UILabel = {
                let label = UILabel()
                    label.textColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
                label.text = "О нашей компании".localized()
                
                return label
            }()
            return settingsLabel
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1{
            let vc = SelectionViewController(question: "Выберите язык:".localized(), optionOne: "Қазақ тілі", optionTwo: "Русский",selectionType: .language)
                vc.modalPresentationStyle = .overFullScreen
            self.present(vc,animated: true)
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(AboutUsViewController(pageType: .aboutUs), animated: true)
            }
            else if indexPath.row == 1 {
                self.navigationController?.pushViewController(AboutUsViewController(pageType: .terms), animated: true)
            }
            else if indexPath.row == 2{
                self.navigationController?.pushViewController(AboutUsViewController(pageType: .partners), animated: true)
            }
        }
    }
}
