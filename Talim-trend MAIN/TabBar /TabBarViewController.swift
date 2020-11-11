//
//  TabBarViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController : UITabBarController {
    
    var translation: CGFloat = 0.0
    
    lazy var tabbarBackView: UIView = {
        let view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.153, green: 0.161, blue: 0.176, alpha: 0.8)
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.layer.cornerRadius = 20
            view.layer.borderColor = #colorLiteral(red: 0.216, green: 0.22, blue: 0.235, alpha: 1)
            view.layer.borderWidth = 1

        return view
    }()
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
        AppUtility.lockOrientation(.portrait)
       // Or to rotate and lock
       // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
       
   }
    
    private var playerView = PlayerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupTabbar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapPlayerView), name: NSNotification.Name(Keys.openPlayerView), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidePlayerView), name: NSNotification.Name(Keys.hidePlayerView), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.closePlayerView), name: NSNotification.Name(Keys.closePlayerView), object: nil)
      
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
       
 
        
    }

    func setVideoId(id: Int, controller: UIViewController) -> Void{
        self.playerView.id = id
        
    }
    
    func setupTabbar() -> Void {
        let mainController = MainPageViewController().inNavigation()
        mainController.tabBarItem = UITabBarItem.init(title: "Главная".localized(), image: #imageLiteral(resourceName: "home1x"), tag: 0)
        
        let favouriteController = FavoritesViewController().inNavigation()
        favouriteController.tabBarItem = UITabBarItem.init(title: "Избранные".localized(), image: #imageLiteral(resourceName: "fav 1x"), tag: 1)
        
        let subscriptionsController = SubscribtionsViewController().inNavigation()
        subscriptionsController.tabBarItem = UITabBarItem.init(title: "Все".localized(), image: #imageLiteral(resourceName: "all!x"), tag: 2)
        
        let profileController = ProfileViewController().inNavigation()
        profileController.tabBarItem = UITabBarItem.init(title: "Профиль".localized(), image: #imageLiteral(resourceName: "profile 1x"), tag: 3)
        
        viewControllers = [mainController, favouriteController, subscriptionsController, profileController]
    }
    
    private func maximizePlayerView() -> Void {
        AppUtility.lockOrientation(nil)
        UIView.animate(withDuration: 0.3, animations: {
            self.playerView.snp.remakeConstraints { (make) in
                make.left.bottom.right.equalToSuperview()
                make.top.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }) { (bool) in
            self.playerView.isHidden = false
        }
    }

    
    private func minimizePlayerView(complitionHandler : (()->())?) -> Void {
        AppUtility.lockOrientation(.portrait)
        UIView.animate(withDuration: 0.3) {
            self.playerView.snp.remakeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(60)
                make.bottom.equalTo(self.tabbarBackView.snp.top).offset(-18)
            }
            self.view.layoutIfNeeded()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
           complitionHandler?()
        }
        
    }

    private func closePlayer() {
        AppUtility.lockOrientation(.portrait)
        UIView.animate(withDuration: 0.3, animations: {
            self.playerView.snp.remakeConstraints { (make) in
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.top.equalTo(self.view.snp.bottom)
                make.height.equalTo(60)
            }
            self.view.layoutIfNeeded()
        }) { (bool) in
            self.playerView.isHidden = true
        }
    }
    
    @objc func tapPlayerView() {
        if let id = UserManager.getVideoId() {
            setVideoId(id: id, controller: UIViewController())
            UserDefaults.standard.setValue(nil, forKey: Keys.videoID)
        }
        maximizePlayerView()
    }
    
    @objc func hidePlayerView() {
        minimizePlayerView(complitionHandler: nil)
    }
    
    @objc func closePlayerView() {
        closePlayer()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.orientation.isLandscape {
          
            
        }
       else {

    
        //DONT DELETE ASYNC !!!!!!!
        DispatchQueue.main.async {
            self.playerView.remakeConstraintsAfterFlip()
            self.view.layoutIfNeeded()
        }

       }
  
    }
    

}

extension TabBarViewController {
    private func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
        setupActions()
    }
    
    private func addSubviews() {
        view.addSubview(playerView)

       
    }
    
    private func addConstraints() {
        playerView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }

    }
    
    private func stylizeViews() {
        tabBar.barTintColor = UIColor.clear
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = #colorLiteral(red: 0.702, green: 0.243, blue: 0.424, alpha: 1)
        tabBar.insertSubview(tabbarBackView, at: 0)

        tabbarBackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(tabBar)
        }


        self.playerView.isHidden = true
        self.playerView.delegate = self
    }
   
    private func setupActions() {
        let commentsVC = CommentsViewController()
        playerView.openCommentPageClosure = { [unowned self] id in
            commentsVC.videoId = id
            self.minimizePlayerView(complitionHandler: { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.pushViewController(commentsVC, animated: true)
            })
        }
        playerView.actionsView.downloadAction = {
            
            self.showAlert(type: .success, "Видео сохранится в галлерее ")
        }
        playerView.openAuthorPage = { [unowned self] id in

            self.minimizePlayerView(complitionHandler: { [weak self] in
                guard let `self` = self else { return }
                self.navigationController?.pushViewController(AuthorProfileViewController(id: id), animated: true)
            })
        }
        
        
        playerView.actionsView.presentActivityViewController = { urlString in
            let items = [urlString.url]
            self.present(UIActivityViewController(activityItems: items, applicationActivities: nil),animated: true)
        }
        playerView.actionsView.failedToLogIn = {
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.present(vc,animated: true)
        }
        playerView.actionsView.videoWasSavedAction = { [unowned self] items in
        
            let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityVC.setValue("Video", forKey: "subject")
        
            self.present(activityVC, animated: true, completion: nil)
            
        }
        playerView.actionsView.percentDownloaded = { percent in
            print(percent)
        }
        
        playerView.chanelView.failedToLogin = {
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc,animated: true)
        }
        playerView.failedToLogIn = {
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc,animated: true)
        }
        
        
        self.playerView.playerView.playerView.presentSettingsAction = {
            let settingsVC =  SettingViewController(type: .player)
            settingsVC.modalPresentationStyle = .fullScreen
            
            settingsVC.playSpeedViewController.saveSpeedSettings = { playbackSpeed in
            
                
                self.playerView.playerView.playerView.vgPlayer?.player?.playImmediately(atRate: Float(playbackSpeed))
              //  self.playerView.playerView.playerView.vgPlayer?.state = .playing
                self.playerView.playerView.playerView.playButtion.isSelected = true
            }
            
            self.present(settingsVC.inNavigation(), animated: true, completion: nil)
        }
    }
   
}

extension TabBarViewController: PlayerVCDelegate {
    func swipeToMinimize(translation: CGFloat, toState: stateOfVC) {
        self.translation = translation
        print("translation: ".uppercased(), "\(translation)")
        
        self.playerView.snp.remakeConstraints { (make) in
            make.left.equalTo(16*translation)
            make.bottom.equalTo(-(self.tabbarBackView.bounds.height+18)*translation)
            make.right.equalTo(-16*translation)
            make.height.equalTo(AppConstants.screenHeight - (AppConstants.screenHeight*translation)+60)
        }
        self.view.layoutIfNeeded()
    }
    
    func didEndSwipe(toState: stateOfVC) {
        switch toState {
        case .fullScreen:
            if translation < 0.5 {
                self.playerView.snp.remakeConstraints { (make) in
                    make.left.bottom.right.equalToSuperview()
                    make.top.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            } else {
                self.playerView.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.right.equalTo(-16)
                    make.height.equalTo(60)
                    make.bottom.equalTo(self.tabbarBackView.snp.top).offset(-18)
                }
                self.view.layoutIfNeeded()
            }
        case .minimized:
            if translation < 0.5 {
                self.playerView.snp.remakeConstraints { (make) in
                    make.left.bottom.right.equalToSuperview()
                    make.top.equalToSuperview()
                }
                self.view.layoutIfNeeded()
            } else {
                self.playerView.snp.remakeConstraints { (make) in
                    make.left.equalTo(16)
                    make.right.equalTo(-16)
                    make.height.equalTo(60)
                    make.bottom.equalTo(self.tabbarBackView.snp.top).offset(-18)
                }
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
