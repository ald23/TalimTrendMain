//
//  RegistrationModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/10/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation

struct RegistrationModel: Codable {
    var user: AuthorizationModel
}

struct AuthorizationModel: Codable {
    var first_name: String?
    var last_name: String?
    var access_token: String?
    var local_lang : String?

    var id: Int?
}
