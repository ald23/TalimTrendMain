//
//  Parser.swift
//  NetworkManager
//
//  Created by Yerassyl Zhassuzakhov on 4/30/19.
//  Copyright © 2019 Yerassyl Zhassuzakhov. All rights reserved.
//

import Foundation

public protocol Parser {
    func parse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Result<T>
}

public class DefaultParserImpl: Parser {
    public init() {}
    
    public func parse<T>(data: Data?, response: URLResponse?, error: Error?) -> Result<T> where T : Decodable {
        if let error = error {
            return .failure(error.localizedDescription)
        }
        guard let response = response as? HTTPURLResponse else { return .failure("Response is not in HTTPResponse format") }
        switch response.statusCode {
        case 200...499:
            guard let data = data else { return .failure(NetworkResponse.noData.rawValue) }
            
            

            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("JSON:", json)
                
//                print("MESSAGE: ", (json as! [String: Any])["message"] as! String)
            } catch {
                
                print("Error with json:", error.localizedDescription)
            }
            
            return decode(data, response: response)
        case 300...399:
            return .failure(NetworkResponse.redirect.rawValue)
        case 400...499:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 500...501:
            
//            guard let data = data else { return .failure(NetworkResponse.noData.rawValue) }
            
//            let string = String(data: data, encoding: .utf8)
//            print("Internal error: ", string)
            
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }
    
    private func decode<T: Decodable>(_ data: Data, response: HTTPURLResponse) -> Result<T> {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            if response.statusCode == 200 {
                return .success(result)
            } else {
                if let response = try? decoder.decode(ErrorModel.self, from: data) {
                    
                    return .failure("\(response.message)")
                }
                return .failure("error")
            }
        } catch {
            
            if let response = try? decoder.decode(ErrorModel.self, from: data) {
                
                return .failure("\(response.message)")
            }
            return .failure(error.localizedDescription)
        }
    }
}
