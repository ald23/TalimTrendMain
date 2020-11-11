//
//  ParseManager.swift
//  JTI
//
//  Created by Nursultan on 10/17/19.
//  Copyright © 2019 Nursultan. All rights reserved.
//

import Foundation

class ParseManager {
    
    static let shared = ParseManager()
    
    let networkManager: NetworkManager = Router(parser: DefaultParserImpl())
    
    private init() {}
    
    func multipartFormData<T: Decodable>(url: String, parameters: Parameters? = nil,
                                         success: @escaping (T) -> (), error: @escaping (String) -> ()) {
        let endpoint = Endpoints.multipartFormData(url: url, parameters: parameters, token: UserSettings.getCurrentToken() ?? "")
        let dispatch = DispatchQueue.global(qos: .utility)
        dispatch.async {
            self.networkManager.request(endpoint) { (result: Result<T>) in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let errorMessage):
                        error(errorMessage)
                    case .success(let value):
                        success(value)
                    }
                }
            }
        }
    }
    
    func postRequest<T: Decodable>(url: String, parameters: Parameters? = nil, token: String? = UserSettings.getCurrentToken(), success: @escaping (T) -> (), error: @escaping (String) -> ()) {
        let endpoint = Endpoints.post(url: url, parameters: parameters, token: token)
        self.networkManager.request(endpoint) { (result: Result<T>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let errorMessage):
                    error(errorMessage)
                case .success(let value):
                    success(value)
                }
            }
        }
    }
    
    func getRequest<T: Decodable>(url: String, parameters: Parameters? = nil, token: String? = UserSettings.getCurrentToken(),
                                  success: @escaping (T) -> (), error: @escaping (String) -> ()) {
        let endpoint = Endpoints.get(url: url, parameters: parameters, token: token)
        
        self.networkManager.request(endpoint) { (result: Result<T>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let errorMessage):
                    error(errorMessage)
                case .success(let value):
                    success(value)
                }
            }
        }
    }
    func putRequest<T: Decodable>(url: String, parameters: Parameters? = nil, token: String? = UserSettings.getCurrentToken(), header: HTTPHeaders = [:], success: @escaping (T) -> (), error: @escaping (String) -> ()) {
        let endpoint = Endpoints.put(url: url, parameters: parameters, token: token, header: header)
        self.networkManager.request(endpoint) { (result: Result<T>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let errorMessage):
                    error(errorMessage)
                case .success(let value):
                    success(value)
                }
            }
        }
    }
    
    func deleteRequest<T: Decodable>(url: String, parameters: Parameters? = nil, url_parameters: Parameters? = nil,
                                   success: @escaping (T) -> (), error: @escaping (String) -> ()) {
        let endpoint = Endpoints.delete(url: url, parameters: nil, url_parameters: url_parameters, token: UserSettings.getCurrentToken())
        self.networkManager.request(endpoint) { (result: Result<T>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let errorMessage):
                    error(errorMessage)
                case .success(let value):
                    success(value)
                }
            }
        }
    }
   
}
