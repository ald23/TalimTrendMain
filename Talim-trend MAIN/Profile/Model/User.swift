//
//  User.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/19/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class User: Decodable {
    var id : Int
    var first_name : String
    var last_name: String
    var avatar : String?
    var phone : String
    var notification : Int?
    var access_token : String?
}

class RestoreModel : Decodable{
    var access_token : String?
}
