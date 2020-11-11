//
//  FavoritesViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import  UIKit

class FavoritesViewController: UIViewController{
 
    var viewModel = FavoritesViewModel()
    var favoritesLabel : UILabel = {
        var label = UILabel()
        label.text = "Добавьте в избранное понравившиеся видео".localized()
            label.numberOfLines = 0
            label.font = .getSourceSansProRegular(of: 17)
            label.textColor = .white
            label.textAlignment = .center
        
        return label
    }()
    var currentPage = 1
    {
        didSet {
            parameters["page"] = currentPage
        }
    }
    var shouldFetch = false
    var navBar : NavigationBarView = {
        var navBar = NavigationBarView(title: "Избранные".localized(), rightButtonImage: #imageLiteral(resourceName: "saveTT"), leftButtonImage: #imageLiteral(resourceName: "findTT"))
        return navBar
    }()
    let refreshControll = UIRefreshControl()
    var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
        tableView.separatorStyle = .none
        
        return tableView
    }()
    var parameters = ["page": 1, "limit":20]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewModel.getLikedVideos(parameters: parameters)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        authorizationCheck()
        setupView()
        setupTableView()
        bind()
        setupNavBarAction()
    }
    private func setupNavBarAction(){

        navBar.leftButtonAction = {
            self.navigationController?.pushViewController(SearchViewController(), animated: true)
        }
        navBar.rightButtonTarget = {
            
            self.navigationController?.pushViewController(SearchByTagsViewController(), animated: true)
        }
    }
    func authorizationCheck(){
        if !UserManager.isAuthorized(){
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.present(vc,animated: true)
        }
    }
    func bind(){
        guard UserManager.isAuthorized() else {return }
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
        viewModel.videos.observe(on: self) { [self] (video) in
                self.tableView.reloadData()
                self.shouldFetch = true
            }
        viewModel.update.observe(on: self) { [self] (video) in
            self.tableView.reloadData()
           
        }
        }
    
        func setupTableView()
        {
            tableView.refreshControl = refreshControll
            refreshControll.addTarget(self, action: #selector(updateView), for: .valueChanged)
            tableView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
            tableView.delegate = self
            tableView.dataSource = self
        }
    @objc func updateView(){
        self.viewModel.videos.value.removeAll()
        self.currentPage = 1
        viewModel.getLikedVideos(parameters: self.parameters)
        refreshControll.endRefreshing()
    }
        func setupView(){
            view.addSubview(navBar)
            navBar.snp.makeConstraints { (make) in
                make.top.equalTo(AppConstants.statusBarHeight)
                make.left.right.equalToSuperview()
                make.height.equalTo(AppConstants.navBarHeight)
            }
            view.addSubview(tableView)
            tableView.snp.makeConstraints { (make) in
                make.top.equalTo(navBar.snp.bottom)
                make.left.right.bottom.equalToSuperview()
            }
            view.addSubview(favoritesLabel)
            favoritesLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.left.equalTo(40)
                make.right.equalTo(-40)
            }
        }
}

extension FavoritesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoritesLabel.isHidden = !(viewModel.videos.value.count == 0)
        tableView.isHidden = viewModel.videos.value.count == 0
        
        return viewModel.videos.value.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.videos.value.count && shouldFetch{
            shouldFetch = false
            currentPage += 1
            parameters["page"] = currentPage
            viewModel.getLikedVideos(parameters: parameters)
     }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(),for: indexPath) as! VideoTableViewCell
            cell.selectionStyle = .none
            cell.setupData(data: viewModel.videos.value[indexPath.row])
        cell.shareActionTarget = { (link, favorite, id) in
            let vc = SettingViewController(type: .shareButton)
            vc.inFavorite = favorite
            vc.shareLink = link
            vc.id = id
            vc.didChangeFavorites = {
                self.viewModel.videos.value.removeAll()
                self.currentPage = 1
                self.parameters["page"] = self.currentPage
                self.viewModel.getLikedVideos(parameters: self.parameters)
                self.tableView.reloadData()
            }
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
//MARK:- DONT REMOVE
        
        
//            cell.followButton.selectionBlock = { [weak self] in
//                guard let `self` = self else { return }
//                if self.viewModel.videos.value[indexPath.row].author != nil {
//                    self.videos.getSubscribe(id: author.id, isAuthor: 1, index: indexPath.row, completion: {
//                        cell.followButton.isselected.toggle()
//                    })
//                }
//            }
        

        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
        (tabBarController as! TabBarViewController).setVideoId(id: viewModel.videos.value[indexPath.row].id, controller: self)
    }
    
    
}
