//
//  Result.swift
//  InMaster
//
//  Created by Nurzhigit Smailov on 8/16/19.
//  Copyright © 2019 Nurzhigit Smailov. All rights reserved.
//

import Foundation

public enum Result<T: Decodable> {
    case failure(String)
    case success(T)
}

public class ErrorModel: Decodable {
    var message: String
}

public class GeneralPagination<T: Decodable> : Decodable {
    var message: String
    var result: T
}

public class GeneralResult<T: Decodable> : Decodable {
    let statusCode: Int
    let message: String
    let result: T
}

public class PageResult<T: Decodable> : Decodable {
    let count: Int
    let pages: Int
    let offset: Int
    let data: T
}
