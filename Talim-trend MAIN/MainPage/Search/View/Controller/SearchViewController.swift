//
//  SearchViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class SearchViewController: UIViewController {
    
    var navBar = NavigationBarView(title: "Поиск".localized(), leftButtonImage: #imageLiteral(resourceName: "back"))
    var searchView = SearchView()
    var switcherValue = "name"
    var viewModel = SearchViewModel()
    var numberOfSections = 2
    var searchHistoryView = SearchViewForTableViewCell()
    var searchTableView = UITableView()
    var  currentPage = 1
    var  shouldKeepPagination = true
    var searchParameters : Parameters = ["parameter":"name","page":1]
    var categoryId : Int?
    var searchButton = BigMainButton(title: "Искать".localized(), background: .gradient)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchButton.setupButtonStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getComments()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        setupTableViews()
        setupSearch()
        bind()
        KeyboardAvoiding.avoidingView = self.searchButton
    }
    func bind(){
        viewModel.videos.observe(on: self) { (video) in
         self.searchTableView.reloadSections(IndexSet(integer: 2), with: .fade)
         
        }
        viewModel.searchHistory.observe(on: self) { history in
            self.searchTableView.reloadSections(IndexSet(integer: 0), with: .fade)
            self.shouldKeepPagination = true
        }
        viewModel.message.observe(on: self) { message in
              self.viewModel.getComments()
        }
        
    }

    func setupSearch(){
        searchView.detectChanges = { (text) in
            self.searchParameters["target"] = text
        }
    }
    func setupTableViews(){
        searchTableView.isHidden = false
        searchTableView.backgroundColor = .clear
        searchTableView.register(SearchHistoryTableViewCell.self, forCellReuseIdentifier: SearchHistoryTableViewCell.cellIdentifier())
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellIdentifier())
        searchTableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }

    func setupAction(){
        navBar.leftButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        searchButton.action  = { [unowned self] in
            self.viewModel.getVideosSearch(parameters: self.searchParameters)
            self.viewModel.getComments()
        }
        searchHistoryView.clearAllBlock = {
            self.viewModel.removeComments()
        }
    }

    func setupView(){
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.navBarHeight)
        }
        addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(19)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        addSubview(searchTableView)
           searchTableView.snp.makeConstraints { (make) in
               make.top.equalTo(searchView.snp.bottom).offset(25)
               make.left.right.bottom.equalToSuperview()
        }
        addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-AppConstants.getTabbarHeight(tabBarController) - 10)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
            
        }
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchHistoryView.clearAllButton.isHidden = viewModel.searchHistory.value.count == 0
        if section == 0  {
            if viewModel.searchHistory.value.count > 4{
            return 4
            }
            else {
                return viewModel.searchHistory.value.count
            }
        }
        if section == 1{
            return 0
        }
        else if section == 2{
            return viewModel.videos.value.count
        }

        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
            return 3
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

         if tableView == searchTableView{
            if section == 0{
                return searchHistoryView
            }
            if section == 1 {
                let searchView = SearchByView()
                searchView.searchBySwitcherValueAction = { value in
                    self.switcherValue = value
                }
                searchView.searchBySwitcherValue = switcherValue
                searchView.allParametersAction = { [unowned self] (sectionName, subSectionId)in
                    self.searchParameters["parameter"]  = sectionName
                    if subSectionId != nil{
                        self.searchParameters["category_id"] = subSectionId
                    }
                    else {
                        self.searchParameters.removeValue(forKey: "category_id")
                    }
                }
                return searchView
            }
        }
        return UIView()
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
         if tableView == searchTableView{
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.cellIdentifier(), for: indexPath) as! SearchHistoryTableViewCell
                    cell.selectionStyle = .none
                    if indexPath.row < viewModel.searchHistory.value.count{
                        cell.setupData(comment: viewModel.searchHistory.value[indexPath.row])
                    }
                
                
                return cell
            }
            if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(), for: indexPath) as! VideoTableViewCell
                    cell.selectionStyle = .none
                    cell.setupData(data: viewModel.videos.value[indexPath.row])
                
                return cell
                       
            }
            
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
            (tabBarController as! TabBarViewController).setVideoId(id: viewModel.videos.value[indexPath.row].id, controller: self)
        }
        if indexPath.section == 0{
            searchView.searchTextView.text = viewModel.searchHistory.value[indexPath.row].text
            self.viewModel.getVideosSearch(parameters: self.searchParameters)
            self.viewModel.getComments()
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == viewModel.videos.value.count && shouldKeepPagination{
            shouldKeepPagination = false
            self.currentPage += 1
            searchParameters["page"] = currentPage
            viewModel.getVideosSearch(parameters: searchParameters)
     }
    }
}
