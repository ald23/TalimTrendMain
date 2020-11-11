//
//  CustomSwitch.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/15/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

import UIKit

class CustomSwitch: UIControl {
    
    public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var onTintColor = #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }
    public var offTintColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbTintColor = #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.1764705882, alpha: 1) {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var isOn = true
    
    public var animationDuration: Double = 0.5
    
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    
    fileprivate var onPoint = CGPoint.zero
    
    fileprivate var offPoint = CGPoint.zero
    
    fileprivate var isAnimating = false
    
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.setupUI()
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            
            // thumb managment
            
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            
        }
        
    }
    
    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    

    
}
