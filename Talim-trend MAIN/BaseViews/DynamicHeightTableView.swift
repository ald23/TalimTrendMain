//
//  DynamicHeightTableView.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
