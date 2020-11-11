//
//  VideoDetailModel.swift
//  Talim-trend MAIN
//
//  Created by Eldor Makkambayev on 8/18/20.
//  Copyright © 2020 Aldiyar Massimkhanov. All rights reserved.
//

import Foundation
class VideoDetailModel: Codable {
    var video: Video
    var author: Author
    var nextVideo: Video?
    var prevVideo: Video?
}
