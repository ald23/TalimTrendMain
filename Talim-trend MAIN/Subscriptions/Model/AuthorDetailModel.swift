//
//  AuthorDetailModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class AuthorDetailModel<T: Decodable>: Decodable {
    var author: Author
    var videos: T
}

