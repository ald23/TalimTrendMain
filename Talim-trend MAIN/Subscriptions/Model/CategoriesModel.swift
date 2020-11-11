//
//  CategoriesModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class CategoriesModel<T: Decodable> : Decodable {
    var categories: T
}

class Category: Codable {
    var id: Int
    var name: String
    var avatar: String?
    var preview: String?
    var description: String
    var video_count: Int
    var subscribers_count: Int
    var is_subscribed: Bool
}
