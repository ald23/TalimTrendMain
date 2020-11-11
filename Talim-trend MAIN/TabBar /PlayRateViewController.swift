//
//  PlayRateViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class PlayRateViewConroller: LoaderBaseViewController {
    var tableView = UITableView()
    var navBar = SmallNavigationBar(leftButtonImage: #imageLiteral(resourceName: "back"), title: "Скорость".localized())
    var speedArray = [0.25,0.5, 0.75,1,1.25,1.5,1.75,2]
    var saveSpeedSettings = {(selectedSpeed : Double)->() in} 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        mainView.round(corners: [.topLeft, .topRight], radius: 20)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        navBar.leftButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func setupTableView(){
        tableView.register(PlayRateTableView.self, forCellReuseIdentifier: PlayRateTableView.cellIdentifier())
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func setupView() -> Void {
        addSubview(mainView)
        addSubview(viewOnTopOfMainForDismissing)
        mainView.snp.makeConstraints { (make) in
            make.height.equalTo(AppConstants.screenHeight/2)
            make.bottom.left.right.equalToSuperview()
        }
        
        mainView.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.smallNavBarHeight)
        }
        mainView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.smallNavBarHeight + 10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview()
        }
    }
}
extension PlayRateViewConroller : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        speedArray.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlayRateTableView.cellIdentifier(), for: indexPath)
        as! PlayRateTableView
        cell.titleLabel.text = indexPath.row == 3 ? "Обычная".localized() : String(describing: speedArray[indexPath.row])
            cell.selectionStyle = .none
            
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveSpeedSettings(speedArray[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

class PlayRateTableView : UITableViewCell {
    var titleLabel : UILabel = {
        var label = UILabel()
            label.layer.cornerRadius = 10
            label.textColor = .white
            label.font = .getSourceSansProRegular(of: 14)
            label.textAlignment = .center
        
        return label
    }()
    var mainView : UIView = {
        var view = UIView()
            view.backgroundColor = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
            view.layer.cornerRadius = 10
            
        return view
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupView()
    }
    func setupView(){
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.top.equalTo(6)
            make.left.right.equalToSuperview()
        }
        mainView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.left.equalTo(8)
            make.right.bottom.equalTo(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

