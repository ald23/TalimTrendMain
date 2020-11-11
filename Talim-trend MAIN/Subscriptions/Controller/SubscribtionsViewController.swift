//
//  SubscribtionsViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/13/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

enum TableViewType {
    case category
    case author
}

class SubscribtionsViewController: UIViewController {
    
    private var tableViewType: TableViewType = .category
    
    private var viewModel = SubscriptionViewModel()
    private var subscribeButtonViewModel = SubscribeButtonViewModel()
    
    private var navBar = NavigationBarView(title: "Все".localized(), rightButtonImage: #imageLiteral(resourceName: "saveTT"), leftButtonImage: #imageLiteral(resourceName: "findTT"))
    private var switcher = SwitcherView(firstTitle: "Плейлисты".localized(), secondTitle: "Авторы".localized())
    
    private var categoryRefreshControl = UIRefreshControl()
    private var authorRefreshControl = UIRefreshControl()
    
    private var categoriesTableView =  UITableView()
    private var authorsTableView = UITableView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAction()
        setupTableViews()
        setupNavBarAction()
        bind(to: viewModel, subscribeButtonViewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if tableViewType == .category {
            viewModel.getCategories(page: viewModel.categoriesPage, isFirstly: viewModel.categoryList.value.isEmpty)
        } else {
            viewModel.getAuthors(page: viewModel.authorsPage, isFirst: viewModel.authorList.value.isEmpty)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !switcher.isselected {
            setupSwitcherView()
        }
    }
    private func setupNavBarAction(){

        navBar.leftButtonAction = {
            self.navigationController?.pushViewController(SearchViewController(), animated: true)
        }
        navBar.rightButtonTarget = {
            
            self.navigationController?.pushViewController(SearchByTagsViewController(), animated: true)
        }
    }
    
    
    private func bind(to viewModel: SubscriptionViewModel, _ subscribeViewModel: SubscribeButtonViewModel) {
        viewModel.error.observe(on: self) { [weak self] in
            guard  let `self` = self else { return }
            self.showAlert(type: .error, $0)}
        viewModel.loading.observe(on: self) { loading in
            if (loading) {
                LoaderView.show()
            } else {
                self.categoryRefreshControl.endRefreshing()
                self.authorRefreshControl.endRefreshing()
                self.view.isHidden = false
                LoaderView.hide()
            }
        }
        viewModel.categoryList.observe(on: self) { list in
            if !list.isEmpty {
                self.categoriesTableView.reloadData()
            }
        }
        
        viewModel.authorList.observe(on: self) { (list) in
            if !list.isEmpty {
                self.authorsTableView.reloadData()
            }
        }
        
        subscribeViewModel.error.observe(on: self) { [weak self] in
            guard  let `self` = self else { return }
            self.showAlert(type: .error, $0)}
        
        subscribeViewModel.isSelected.observe(on: self) { (selection) in
            if selection.index != -1 {
                if selection.isAuthor {
                    viewModel.authorList.value[selection.index].is_subscribed = selection.isSelected
                } else {
                    viewModel.categoryList.value[selection.index].is_subscribed = selection.isSelected
                }
            }
        }
    }
    
    
    private func setupTableViews(){
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoriesCell.self, forCellReuseIdentifier: CategoriesCell.cellIdentifier())
        categoriesTableView.backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        categoriesTableView.refreshControl = categoryRefreshControl
        categoryRefreshControl.tintColor = .white
        
        
        authorsTableView.isHidden = true
        authorsTableView.delegate = self
        authorsTableView.dataSource = self
        authorsTableView.backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        authorsTableView.register(AuthorsCell.self, forCellReuseIdentifier: AuthorsCell.cellIdentifier())
        authorsTableView.refreshControl = authorRefreshControl
        authorRefreshControl.tintColor = .white
    }
    
    private func setupViews(){
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.navBarHeight)
        }
        
        view.addSubview(switcher)
        switcher.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(20)
            make.left.equalTo(17)
            make.right.equalTo(-17)
        }
        
        view.addSubview(categoriesTableView)
        categoriesTableView.snp.makeConstraints { (make) in
            make.top.equalTo(switcher.snp.bottom).offset(21)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(authorsTableView)
        authorsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(switcher.snp.bottom).offset(21)
            make.left.equalTo(13)
            make.right.equalTo(-17)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupSwitcherView() {
        switcher.firstAction = {
            self.tableViewType = .category
            self.categoriesTableView.isHidden = false
            self.authorsTableView.isHidden = true
        }
        
        switcher.secondAction = {
            self.tableViewType = .author
            if self.viewModel.authorList.value.isEmpty {
                LoaderView.show()
                self.viewModel.getAuthors(page: 1, isFirst: self.viewModel.authorList.value.isEmpty)
            }
            self.categoriesTableView.isHidden = true
            self.authorsTableView.isHidden = false
        }
        
        switcher.firstButtonSelected()
    }
    
    private func setupAction() {
        categoryRefreshControl.addTarget(self, action: #selector(updateCategories), for: .valueChanged)
        authorRefreshControl.addTarget(self, action: #selector(updateAuthors), for: .valueChanged)
    }
    
    @objc private func updateCategories() {
        viewModel.getCategories(page: 1)
    }
    
    @objc private func updateAuthors() {
        viewModel.getAuthors(page: 1)
    }
}

extension SubscribtionsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView == categoriesTableView ? viewModel.categoryList.value.count : viewModel.authorList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == categoriesTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoriesCell.cellIdentifier(), for: indexPath) as! CategoriesCell
            if indexPath.row < viewModel.categoryList.value.count {
                let category = viewModel.categoryList.value[indexPath.row]
                cell.followButton.tag = indexPath.row
                cell.setupData(data: category)
                
                cell.followButton.selectionBlock = { [weak self] in
                    guard UserManager.isAuthorized() else {
                        let vc = WelcomeBackViewController().inNavigation()
                            vc.modalPresentationStyle = .overFullScreen
                        
                        self?.navigationController?.present(vc,animated: true)
                        return
                    }
                    guard let `self` = self else { return }
                    self.subscribeButtonViewModel.getSubscribe(id: category.id, isAuthor: 0, index: indexPath.row, completion: {
                        cell.followButton.isselected.toggle()
                        cell.isselected.toggle()
                        cell.subscribers_count += cell.followButton.isselected ? 1 : -1
                    })
                }
            }
            
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AuthorsCell.cellIdentifier(), for: indexPath) as! AuthorsCell
            if indexPath.row < viewModel.authorList.value.count {
                let author = viewModel.authorList.value[indexPath.row]
                cell.setupData(data: author)
                cell.followButton.selectionBlock = { [weak self] in
                    guard UserManager.isAuthorized() else {
                        let vc = WelcomeBackViewController().inNavigation()
                            vc.modalPresentationStyle = .overFullScreen
                        
                        self?.navigationController?.present(vc,animated: true)
                        return
                    }
                    guard let `self` = self else { return }
                    self.subscribeButtonViewModel.getSubscribe(id: author.id, isAuthor: 1, index: indexPath.row , completion: {
                        cell.followButton.isselected.toggle()
                        cell.isselected.toggle()
                        cell.subscribers_count += cell.followButton.isselected ? 1 : -1
                    })
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == categoriesTableView{
            navigationController?.pushViewController(CategoryViewController(id: viewModel.categoryList.value[indexPath.row].id), animated: true)
            
        }
        else {
            navigationController?.pushViewController(AuthorProfileViewController(id: viewModel.authorList.value[indexPath.row].id), animated: true)
        }
    }
    
    
    
}
