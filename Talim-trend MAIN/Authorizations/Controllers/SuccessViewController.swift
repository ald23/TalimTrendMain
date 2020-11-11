//
//  SuccessViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/20/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
import UIKit

class SuccessViewController: LoaderBaseViewController {
    private var circleView : UIImageView = {
        var circle = UIImageView()
            circle.layer.cornerRadius = 56
            circle.layer.borderColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            circle.layer.borderWidth = 4
            circle.image = #imageLiteral(resourceName: "galochka")
            circle.contentMode = .center
        
        return circle
    }()
    private var successLabel : UILabel = {
        var label = UILabel()
            label.text = "Успешно"
            label.font = .getSourceSansProSemibold(of: 20)
            label.textColor = .boldTextColor
        
        return label
    }()
    private var onMainPageButton = BigMainButton(title: "На главную страницу", background: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
            setupAction()
            setupViews()
            
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           mainView.roundCorners(corners: [.topLeft, .topRight], radius: 30)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        AppCenter.shared.start()
    }
    
    fileprivate func setupAction() {
        onMainPageButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        let dismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        viewOnTopOfMainForDismissing.addGestureRecognizer(dismissGestureRecognizer)
    }
    
    
    func setupViews(){
        addSubview(mainView)
            mainView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(345)
        }
        addSubview(viewOnTopOfMainForDismissing)
            viewOnTopOfMainForDismissing.snp.makeConstraints { (make) in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(mainView.snp.top)
        }
        mainView.addSubview(circleView)
            circleView.snp.makeConstraints { (make) in
                make.top.equalTo(25)
                make.width.height.equalTo(112)
                make.centerX.equalToSuperview()
        }
        mainView.addSubview(successLabel)
            successLabel.snp.makeConstraints { (make) in
                make.top.equalTo(circleView.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
        }
        mainView.addSubview(onMainPageButton)
            onMainPageButton.snp.makeConstraints { (make) in
                make.top.equalTo(successLabel.snp.bottom).offset(65)
                make.left.equalTo(17)
                make.right.equalTo(-17)
                make.height.equalTo(50)
        }
        
    }
}
