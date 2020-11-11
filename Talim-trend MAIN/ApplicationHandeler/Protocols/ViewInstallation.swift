//
//  ViewInstallation.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 7/21/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

protocol ViewInstallation {
    func addSubviews()
    func addConstraints()
    func stylizeViews()
    
}
extension ViewInstallation {
    func setupViews() {
        addSubviews()
        addConstraints()
        stylizeViews()
    }
}
