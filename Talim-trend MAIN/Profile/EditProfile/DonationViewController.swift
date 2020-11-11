//
//  DonationViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/16/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class DonationViewController: LoaderBaseViewController {
    //MARK: - proporties
    private var smallNavBar = SmallNavigationBar(title: "Хотите поддержать проект финансово?")//tiny navbar on top of mainView
    private var donateButton = BigMainButton(title: "Продолжить", background: .gradient)
    private var donateLabel : UILabel = {
        var label = UILabel()
            label.text = "Кнопка приведет вас на страницу скачивания соответсвующего приложения"
            label.textAlignment = .center
            label.textColor = .grayForText
            label.font = .getSourceSansProRegular(of: 12)
            label.numberOfLines = 0
        
        return label
    }()
    
    //MARK: - lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
        //neccessary when using gradient background
        donateButton.setupButtonStyle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDismiss()
    }
    //MARK: - setup
    private func setupDismiss(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(gesture)
    }
 
    private func setupViews(){
        addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(229)
        }
        
        addSubview(viewOnTopOfMainForDismissing)
        viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(mainView.snp.top)
        }
        
        mainView.addSubview(smallNavBar)
        smallNavBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(AppConstants.smallNavBarHeight)
        }
        
        mainView.addSubview(donateLabel)
        donateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(smallNavBar.snp.bottom).offset(8)
            make.left.equalTo(70)
            make.right.equalTo(-70)
        }
        
        mainView.addSubview(donateButton)
        donateButton.snp.makeConstraints { (make) in
            make.top.equalTo(donateLabel.snp.bottom).offset(51)
            make.left.equalTo(17)
            make.right.equalTo(-17)
            make.height.equalTo(50)
        }
    }
}
