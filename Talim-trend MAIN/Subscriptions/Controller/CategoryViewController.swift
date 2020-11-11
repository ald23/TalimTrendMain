//
//  CategoryViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class CategoryViewController: UIViewController {
    
    private var id: Int
    private var viewModel = CategoryViewModel()
    private var subscribeButtonViewModel = SubscribeButtonViewModel()
    var shouldKeepPagination = false
    private var navBar = NavigationBarView(title: "Воспитание ребенка",  leftButtonImage: #imageLiteral(resourceName: "back"))
    private var categoryProfileView = ChanelCategoryView()
    private var refreshControl = UIRefreshControl()
    private var tableView = UITableView()
    private var currentPage = 1
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        setupActions()
        bind(to: viewModel, subscribeButtonViewModel)
        viewModel.getCategory(by: id)
    }
  
    private func bind(to viewModel: CategoryViewModel, _ subscribeViewModel: SubscribeButtonViewModel) {
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
        viewModel.categoryInfo.observe(on: self) { [weak self] info in
            guard let info = info, let `self` = self else { return }
            self.categoryProfileView.setupData(data: info)
            self.navBar.titleLabel.text = info.name
        }
        
        viewModel.categoryVideoList.observe(on: self) { [weak self] (list) in
            guard let `self` = self else { return }
            if !list.isEmpty {
                self.tableView.reloadData()
                self.shouldKeepPagination = true
            }
        }
        
        subscribeViewModel.error.observe(on: self) { [weak self] in
            guard  let `self` = self else { return }
            self.showAlert(type: .error, $0)}
        
        subscribeViewModel.isSelected.observe(on: self) { [weak self] (selection) in
            guard  let `self` = self else { return }
            if selection.index != -1 {
                if selection.index != -2 {
                    if let author = viewModel.categoryVideoList.value[selection.index].author {
                       author.is_subscribed = selection.isSelected
                        
                    }

                } else {
                    self.categoryProfileView.followButton.isselected.toggle()
                    self.categoryProfileView.subscribers_count += self.categoryProfileView.followButton.isselected ? 1 : -1
                }
            }
        }

    }

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
    
    
    private func setupViews(){
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
    
    private func setupActions() {
        navBar.leftButtonAction = { [weak self] in
           guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }

        categoryProfileView.followButton.selectionBlock = { [weak self] in
            guard UserManager.isAuthorized() else {
                let vc = WelcomeBackViewController().inNavigation()
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true, completion: nil)
                return
            }
            guard let `self` = self else { return }
            self.subscribeButtonViewModel.getSubscribe(id: self.id, isAuthor: 0, index: -2)
        }
    }
    
    @objc func refresh() {
        viewModel.getCategory(by: id)
    }
}

extension CategoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        [0, viewModel.categoryVideoList.value.count][section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(),for: indexPath) as! VideoTableViewCell
        cell.setupData(data: viewModel.categoryVideoList.value[indexPath.row])
//        cell.followButton.selectionBlock = { [weak self] in
//            guard let `self` = self else { return }
//            if let author = self.viewModel.categoryVideoList.value[indexPath.row].author {
//                self.subscribeButtonViewModel.getSubscribe(id: author.id, isAuthor: 1, index: indexPath.row, completion: {
//                    cell.followButton.isselected.toggle()
//                })
//            }
//        }
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
        
        (tabBarController as! TabBarViewController).setVideoId(id: viewModel.categoryVideoList.value[indexPath.row].id, controller: self)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        [categoryProfileView, nil][section]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        [UITableView.automaticDimension, 0][section]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.categoryVideoList.value.count && shouldKeepPagination{
            shouldKeepPagination = false
            self.currentPage += 1
            
            viewModel.getCategory(by: id, page : currentPage)
     }
    }
    
}
