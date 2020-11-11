//
//  LoaderBaseViewController.swift
//  Atlas
//
//  Created by Eldor Makkambayev on 1/13/20.
//  Copyright © 2020 Eldor Makkambayev. All rights reserved.
//

import UIKit
import IQKeyboardManager

class LoaderBaseViewController: ScrollViewController {
   

    //small gray view on some viewControllers like : WelcomePage
    var mainView: IQPreviousNextView = {
        var view = IQPreviousNextView()
            view.backgroundColor = .overlayLight
    
         return view
    }()
    //view on top for dissmissing mainView
    var viewOnTopOfMainForDismissing : UIView = {
         var view = UIView()
             view.backgroundColor = .clear
             
         return view
     }()
    
    //    MARK: - Properties
    var messageTimer : Timer?
   
    
    var messageBackView: UIView = {
        let view = UIView()
            view.backgroundColor = .white
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.overlayLight.cgColor
            view.layer.cornerRadius = 15
            view.isHidden = true
        
        return view
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
            label.textColor =  UIColor.overlayLight
            label.numberOfLines = 0
            label.preferredMaxLayoutWidth = 150
            label.textAlignment = .center
            label.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        return label
    }()
    
    var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
            loader.hidesWhenStopped = true
            loader.layer.borderColor =  UIColor.clear.cgColor
            loader.layer.borderWidth = 1
            loader.layer.cornerRadius = 15
            loader.layer.masksToBounds = true
            loader.backgroundColor = .clear
        if #available(iOS 13.0, *) {
            loader.style = UIActivityIndicatorView.Style.large
        } else {
            // Fallback on earlier versions
        }
            loader.color = .overlayLight
            loader.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return loader
    }()
    
    //    MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @objc func dismissAction(){
        self.dismiss(animated: true, completion: nil)
     }
    
    
//    MARK: - Setup functions
    func setupLoaderView() -> Void {
        view.addSubview(loader)
        loader.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(80)
        }
        view.addSubview(messageBackView)
        messageBackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        messageBackView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
        }

    }
    

    
    func withoutScrollView() -> Void {
        self.scrollView.removeFromSuperview()
    }

    func showLoader() -> Void {
        self.loader.startAnimating()
    }
    
    func hideLoader() -> Void {
        self.loader.stopAnimating()
    }
    
    func showErrorMessage(_ message: String) -> Void {
        self.hideLoader()
        let resultAttrString = NSMutableAttributedString()
        let simbolAttribute = NSAttributedString(string: "𝖷\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
        
        let messageAttribute = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        resultAttrString.append(simbolAttribute)
        resultAttrString.append(messageAttribute)
        messageLabel.attributedText = resultAttrString//.text = "x\n\(message)"
        
        self.messageBackView.alpha = 1
        messageBackView.isHidden = false
        messageTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(hideMessageLabel), userInfo: nil, repeats: false)

    }
    
    func showSuccess(_ message: String? = nil) -> Void {
        self.hideLoader()
        if let message = message {
            let resultAttrString = NSMutableAttributedString()
            let simbolAttribute = NSAttributedString(string: "✓", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
            
            let messageAttribute = NSAttributedString(string: "\n\(message)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            resultAttrString.append(simbolAttribute)
            resultAttrString.append(messageAttribute)
            messageLabel.attributedText = resultAttrString
        } else {
            let resultAttrString = NSMutableAttributedString()
            let simbolAttribute = NSAttributedString(string: "✓", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
            
            resultAttrString.append(simbolAttribute)
            messageLabel.attributedText = resultAttrString

        }
        
        self.messageBackView.alpha = 1
        messageBackView.isHidden = false
        messageTimer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(hideMessageLabel), userInfo: nil, repeats: false)

    }
    
    @objc private func hideMessageLabel() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.messageBackView.alpha = 0
        }) { (Bool) in
            self.messageBackView.isHidden = true

        }
        messageTimer?.invalidate()
        messageTimer = nil
        
    }


}
