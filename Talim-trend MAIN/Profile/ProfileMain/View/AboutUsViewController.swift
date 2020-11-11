//
//  AboutUsViewController.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 9/17/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit
enum PageType {
    case aboutUs
    case policy
    case terms
    case partners
}
class AboutUsViewController: LoaderBaseViewController {
    var pageType : PageType!
    var viewModel = AboutUsViewModel()
    
    init(pageType : PageType ){
        super.init(nibName: nil, bundle: nil)
        self.pageType = pageType
    }
    var aboutLabel : UILabel = {
        var label = UILabel()
            label.font = .getSourceSansProRegular(of: 14)
            label.textColor = .grayForText
            label.numberOfLines = 0
        
        return label
    }()
    var navBar = NavigationBarView(title: "О нас".localized(), rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "Group 9034"), rightButtonNeighborImage: nil)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if pageType != .partners {
            viewModel.getAboutUs()
        }
        else {
            viewModel.getPartners()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        navBar.leftButtonAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    func bind(){
        switch pageType {
        case .aboutUs:
            viewModel.about.observe(on: self) { (about) in
                self.aboutLabel.setAttributedHtmlText(about)
                self.navBar.titleLabel.text = "О нас"
                self.aboutLabel.textColor = .grayForText
            }
        case .policy:
            viewModel.policy.observe(on: self) { (policy) in
                self.aboutLabel.setAttributedHtmlText(policy)
                self.navBar.titleLabel.text = "Политика конфиденциальности"
                self.aboutLabel.textColor = .grayForText
            }
        case .terms:
            viewModel.terms.observe(on: self) { (terms) in
                self.aboutLabel.setAttributedHtmlText(terms)
                self.navBar.titleLabel.text = "Правила использования"
                self.aboutLabel.textColor = .grayForText
            }
        case .partners:
            viewModel.partners.observe(on: self) { (partners) in
                self.aboutLabel.setAttributedHtmlText(partners)
                self.navBar.titleLabel.text = "Партнеры".localized()
                self.aboutLabel.textColor = .grayForText
            }
        default:
            break
        }

    }
    func setupViews(){
        self.view.backgroundColor = .backgroundColor
        addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(AppConstants.totalNaBarHeight)
        }
        contentView.addSubview(aboutLabel)
        aboutLabel.snp.makeConstraints { (make) in
            make.top.equalTo(AppConstants.totalNaBarHeight + 20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(0)
        }
    }


}
