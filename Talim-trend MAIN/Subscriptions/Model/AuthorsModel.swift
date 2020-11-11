//
//  AuthorsModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/11/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class AuthorsModel<T: Decodable> : Decodable {
    var authors: T
}

class Author: Codable {
    var id: Int
    var first_name: String
    var last_name: String
    var avatar: String?
    var description: String
    var video_count: Int?
    var subscribers_count: Int?
    var is_subscribed: Bool?
}
