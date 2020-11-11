//
//  NetworkResponse.swift
//  NetworkManager
//
//  Created by Yerassyl Zhassuzakhov on 4/30/19.
//  Copyright © 2019 Yerassyl Zhassuzakhov. All rights reserved.
//

import Foundation

public enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated"
    case badRequest = "Internal server error"
    case outdated = "The url you request is outdated"
    case failed = "Network request failed"
    case noData = "Response returned with no data to decode"
    case unableToDecode = "We could not decode response"
    case redirect = "You should redirect to another URL"
}

//public enum Models: Result<T>{
//    public typealias RawValue = <#type#>
//    
//    
//    case country = "WineCountriesModel"
//}
