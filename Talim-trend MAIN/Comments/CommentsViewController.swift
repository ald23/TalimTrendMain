//
//  CommentsViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/25/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
class CommentsViewController: LoaderBaseViewController {
    var navBar = NavigationBarView(title: "Комментарии", rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "back"), rightButtonNeighborImage: nil)
    var tableView = UITableView()
    var viewModel = CommentViewModel()
    var commentView = LeaveCommentView()
    var videoId = 0
    var parameters : Parameters = ["page" : 1,"limit":90]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        parameters["id"] = videoId
        viewModel.getComments(parameters: parameters)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
        setupView()
        setupTableView()
        bind()
        setupAction()
        
        KeyboardAvoiding.avoidingView = self.commentView
    }
    func setupAction(){
        navBar.leftButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
        commentView.didPressReturnButton = { [unowned self] (text) in
            self.viewModel.leaveComment(parameters: ["text": text, "id": self.videoId])
            self.viewModel.getComments(parameters: self.parameters)
        }
    }
    func bind(){
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
        viewModel.comments.observe(on: self) { comment in
            self.tableView.reloadData()
        }
        
    }
    func setupTableView(){
        tableView.backgroundColor = .clear
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.cellIdentifier())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    func setupView(){
        addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.totalNaBarHeight)
            
        }
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.totalNaBarHeight + 20)
            make.left.equalTo(17)
            
            make.right.equalTo(-17)
        }
       addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom)
            make.bottom.equalTo(-20)
            make.height.equalTo(40)
            make.right.equalTo(-17)
            make.left.equalTo(17)
        }
    }
}
extension CommentsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.comments.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.cellIdentifier() , for: indexPath) as! CommentTableViewCell
            cell.selectionStyle = .none
            cell.setupData(comment: viewModel.comments.value[indexPath.row])
        
        return cell
    }
    
    
}
