//
//  SearchByTagsViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/4/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class SearchByTagsViewController: UIViewController {
    var beforeSearchTableView = UITableView()
    var viewModel = SearchViewModel()
    var currentPage = 1
    var shouldKeepPagination = false
    var parameters : Parameters = ["page": 1, "limit" : 5]
    private var navBar  = NavigationBarView(title: "Хэштеги",  leftButtonImage: #imageLiteral(resourceName: "back"))
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupView()
        bind()
        navBar.leftButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        beforeSearchTableView.reloadData()
    }
    
    func bind(){
        viewModel.videos.observe(on: self) { (video) in
            self.beforeSearchTableView.reloadSections(IndexSet(integer: 2), with: .fade)
            self.shouldKeepPagination = true
        }
    }

    func setupTableView(){
        beforeSearchTableView.dataSource = self
        beforeSearchTableView.delegate = self
    //    beforeSearchTableView.separatorStyle = .none
        beforeSearchTableView.backgroundColor = .clear
        beforeSearchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.cellIdentifier())
        beforeSearchTableView.register(VideoTableViewCell.self, forCellReuseIdentifier: VideoTableViewCell.cellIdentifier())
     
    }
    
    func setupView(){
        view.backgroundColor =  #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.statusBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.navBarHeight)
        }
        addSubview(beforeSearchTableView)
        beforeSearchTableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
}
extension  SearchByTagsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return viewModel.videos.value.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row + 1 == viewModel.videos.value.count && shouldKeepPagination{
            shouldKeepPagination = false
            self.currentPage += 1
            parameters["page"] = currentPage
            viewModel.getVideosByTags(parameters: parameters)
     }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.cellIdentifier(), for: indexPath) as! VideoTableViewCell
                    cell.setupData(data: viewModel.videos.value[indexPath.row])
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
            else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.cellIdentifier(), for: indexPath) as! SearchTableViewCell
                
                cell.sectionCell = indexPath.section
                cell.selectionStyle = .none
                cell.tagSelectionAction = { [unowned self] (tagIds)in
                    self.parameters["page"] = 1
                    
                    if tagIds.count != 0{
                        for i in 0...tagIds.count - 1{
                            self.parameters["tags_ids[\(i)]"] = tagIds[i]
                            
                        }
                        if tagIds.count > self.parameters.count - 2  {
                            self.parameters =  Dictionary(uniqueKeysWithValues: self.parameters.dropLast(tagIds.count - self.parameters.count))
                        }
                        
                    }
                    else {
                        self.parameters.removeAll()
                        self.parameters["page"] = 1
                        self.parameters["limit"] = 1
                    }
                    self.viewModel.videos.value.removeAll()
                    self.viewModel.getVideosByTags(parameters: self.parameters)
     
                }
                cell.categorySelectionAction = {  [unowned self] (categoryId) in
                    if categoryId != nil {
                        self.parameters["category_id"] = categoryId!
                    }
                    else {
                        self.parameters.removeValue(forKey: "category_id")
                    }
                    self.parameters["page"] = 1
                    self.viewModel.videos.value.removeAll()
                    self.viewModel.getVideosByTags(parameters: self.parameters)
                }
            return cell
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == beforeSearchTableView {
            return 3
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tagsLabel = UILabel()
            tagsLabel.font = .getSourceSansProSemibold(of: 15)
            tagsLabel.textColor = .boldTextColor
        
        
         if section == 0{
             tagsLabel.text = "        Хэштеги"
         }
         else if section == 1{
            tagsLabel.text = "        Плейлисты".localized()
         }
         else {
            tagsLabel.text = "        Результаты поиска".localized()
         }
         
         return tagsLabel
         
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            NotificationCenter.default.post(name: Notification.Name(Keys.openPlayerView), object: nil)
            (tabBarController as! TabBarViewController).setVideoId(id: viewModel.videos.value[indexPath.row].id, controller: self)
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

}
