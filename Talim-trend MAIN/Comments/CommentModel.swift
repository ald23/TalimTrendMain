//
//  Model.swift
//  Talim-trend MAIN
//
//  Created by Aldiyar Massimkhanov on 8/26/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

class CommentModel : Decodable{
    var id : Int?
    var user : CommentAuthor?
    var text : String?
    var created_at : String
}
class CommentAuthor : Decodable {
    var first_name : String
    var last_name : String
    var avatar : String?
    var created_at: String
}
