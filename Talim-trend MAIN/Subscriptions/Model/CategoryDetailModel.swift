//
//  CategoryDetailModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class CategoryDetailModel<T: Decodable>: Decodable {
    var category: Category
    var videos: T
}

class Video: Codable {
    var id: Int
    var author: Author?
    var category: String
    var name: String
    var avatar: String?
    var preview: String?
    var path: String?
    var description: String?
    var duration: String?
    var status_id: Int?
    var number_of_views: Int
    var number_of_likes: Int?
    var created_at: String
    var is_favorite: Bool?
    var status : String?
}

