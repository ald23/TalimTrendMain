//
//  MainPageViewController.swift
//  
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//

import Foundation
import UIKit

class MainPageViewController: LoaderBaseViewController{
    
    //MARK: - proporties
    var parameters = Parameters()
    var currentPage = 1
    private var navBar  = NavigationBarView(title: "Главная".localized(), rightButtonImage: #imageLiteral(resourceName: "Filter 2"), leftButtonImage: #imageLiteral(resourceName: "search_major_monotone"))
    var shouldFetch = true
    private var tableView = UITableView()
    private var viewModel = RecentlyWatchedViewModel()
    var refreshControl = UIRefreshControl()
    
    //MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        viewModel.getRecomendations(page: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        setupNavBarAction()
        bind()
        setupLoaderView()
        authorizationCheck()
    }
    func authorizationCheck(){
        if !UserManager.isAuthorized(){
            let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.present(vc,animated: true)
        }
    }
    func bind(){
        viewModel.videoResult.observe(on: self) { (result) in
            self.tableView.reloadData()
            self.shouldFetch = !(result.count == 0)
        }
    }
    //MARK: - setup
    private func setupNavBarAction(){

        navBar.leftButtonAction = {
            self.navigationController?.pushViewController(SearchViewController(), animated: true)
        }
        navBar.rightButtonTarget = {
            self.navigationController?.pushViewController(SearchByTagsViewController(), animated: true)
        }
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(updateView), for: .valueChanged)
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
    }
    @objc func updateView(){
        viewModel.videoResult.value.removeAll()
        currentPage = 1
        viewModel.getRecomendations(page: currentPage)
        refreshControl.endRefreshing()
    }
    private func setupView(){
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
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
    }
}

extension MainPageViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.videoResult.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(),for: indexPath) as! VideoTableViewCell
        cell.contentView.isUserInteractionEnabled = false 
            cell.setupData(data: viewModel.videoResult.value[indexPath.row])
        cell.selectionStyle = .none
        
        cell.shareActionTarget = { (link, favorite, id) in
            let vc = SettingViewController(type: .shareButton)
            vc.inFavorite = favorite
            vc.shareLink = link
            vc.id = id
            vc.modalPresentationStyle = .overFullScreen
            
            self.present(vc, animated: true, completion: nil)
        }
        return cell
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
        (tabBarController as! TabBarViewController).setVideoId(id: viewModel.videoResult.value[indexPath.row].id, controller: self)


    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.videoResult.value.count && shouldFetch{
            shouldFetch = false
            currentPage += 1
            viewModel.getRecomendations(page: currentPage)
     }

    }
}
