//
//  AuthorProfileViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit
class AuthorProfileViewController : LoaderBaseViewController {
    //MARK:- var
    private var id: Int
    private var viewModel = AuthorViewModel()
    private var subscribeButtonViewModel = SubscribeButtonViewModel()
    
    private var navBar = NavigationBarView(title: "Воспитание ребенка",  leftButtonImage: #imageLiteral(resourceName: "back"))
    private var profileView = AuthorProfileView()
    private var refreshControl = UIRefreshControl()
    private var tableView = UITableView()
    private var shouldKeepPagination = true
    var currentPage = 1
    //MARK:- lifestyle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        setupTableView()
        setupActions()
        profileView.descriptionView.action = {
            self.tableView.reloadData()
        }
        
        bind(to: viewModel, subscribeButtonViewModel)
        viewModel.getAuthor(by: id)
    }
    
    private func bind(to viewModel: AuthorViewModel, _ subscribeViewModel: SubscribeButtonViewModel) {
        viewModel.error.observe(on: self) { [weak self] in
            guard  let `self` = self else { return }
            self.showAlert(type: .error, $0)}
        viewModel.loading.observe(on: self) { loading in
            if (loading) {
                LoaderView.show()
            } else {
                self.refreshControl.endRefreshing()
                self.view.isHidden = false
                LoaderView.hide()
            }
        }
        viewModel.authorInfo.observe(on: self) { [weak self] info in
            guard let info = info, let `self` = self else { return }
            self.profileView.setupData(data: info)
            self.navBar.titleLabel.text = info.first_name + " " + info.last_name
        }
        
        viewModel.authorVideoList.observe(on: self) { [weak self] (list) in
            guard let `self` = self else { return }
            if !list.isEmpty {
                self.tableView.reloadData()
            }
        }
        
        subscribeViewModel.error.observe(on: self) { [weak self] in
            guard  let `self` = self else { return }
            self.showAlert(type: .error, $0)}
        
        subscribeViewModel.isSelected.observe(on: self) { [weak self] (selection) in
            guard  let `self` = self else { return }
            if selection.index != -1 {
                self.profileView.followButton.isselected.toggle()
                self.profileView.subscribers_count += self.profileView.followButton.isselected ? 1 : -1

            }
        }
    }
    //MARK:- setup
    private func setupTableView(){
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = .white
        
        tableView.refreshControl = refreshControl
        tableView.separatorStyle = .none
        tableView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
    }
    
    private func setupView()  {
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
    
    private func setupActions() {
        navBar.leftButtonAction = { [weak self] in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
        
        profileView.followButton.selectionBlock = { [weak self] in
            guard UserManager.isAuthorized() else {
                let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
                return
            }

            guard let `self` = self else { return }
            self.subscribeButtonViewModel.getSubscribe(id: self.id, isAuthor: 1, index: 0)
        }
    }
    
    @objc func refresh() {
        viewModel.getAuthor(by: id)
    }
}

extension AuthorProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        [0, viewModel.authorVideoList.value.count][section]
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(),for: indexPath) as! VideoTableViewCell
        cell.setupData(data: viewModel.authorVideoList.value[indexPath.row])
        cell.hideAccountInfo()
        
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        [UITableView.automaticDimension,0][section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
        (tabBarController as! TabBarViewController).setVideoId(id: viewModel.authorVideoList.value[indexPath.row].id, controller: self)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        profileView
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row + 1 == viewModel.authorVideoList.value.count && shouldKeepPagination{
            shouldKeepPagination = false
            self.currentPage += 1
            
            viewModel.getAuthor(by: id, page : currentPage)
     }

    }
    
    
}
