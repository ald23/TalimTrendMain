//
//  Result.swift
//  InMaster
//
//  Created by Eldor Makkambayev on 8/16/19.
//  Copyright © 2019 Eldor Makkambayev. All rights reserved.
//

import Foundation

public enum Result<T: Decodable> {
    case failure(String)
    case success(T)
}

public class GeneralPagination<T: Decodable> : Decodable {
    var message: String
    var result: T
}

public class GeneralResult<T: Decodable> : Decodable {
    let message: String
    let data: T
}

public class PageResult<T: Decodable> : Decodable {
    let page: Int
    let pages: Int
    let count: Int
    let offset: Int
    let data: T
}
