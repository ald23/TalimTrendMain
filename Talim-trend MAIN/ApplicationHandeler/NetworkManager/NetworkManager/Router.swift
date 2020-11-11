//
//  Router.swift
//  NetworkManager
//
//  Created by Yerassyl Zhassuzakhov on 4/30/19.
//  Copyright © 2019 Yerassyl Zhassuzakhov. All rights reserved.
//

import Foundation

public class Router: NetworkManager {
    private var task: URLSessionTask?
    private let parser: Parser
    
    public init(parser: Parser) {
        self.parser = parser
    }
    
    public func request<T: Decodable>(_ route: EndpointType, completion: @escaping (Result<T>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(self.parser.parse(data: data, response: response, error: error))
            })
        } catch {
            completion(.failure(error.localizedDescription))
        }
        
        self.task?.resume()
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    public func buildRequest(from route: EndpointType) throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case let .requestParameters(bodyParameters, urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case let .requestParametersAndHeaders(bodyParameters, urlParameters, additionalHeaders):
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            case let .multipartFormData(bodyParameters, _, headers):
                self.addAdditionalHeaders(headers, request: &request)
                let boundary = generateBoundaryString()
//                try self.configureParameters(bodyParameters: nil, urlParameters: urlParameters, request: &request)
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.httpBody = createBody(bodyParameters, boundary: boundary)
            }
            
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    public func  createBody(_ params: [String: Any]?, boundary: String) -> Data {
        let body = NSMutableData()
        guard let params = params else { return body as Data }
        for (key, value) in params {
            if let dict = value as? NSDictionary {
                for (multiFileKey, multiFileValue) in dict {
                    if let data = multiFileValue as? Data {
                        let mimeTypeLocal = mimeType(for: data)
                        body.append(Data("--\(boundary)\r\n".utf8))
                        body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(multiFileKey)\"\r\n".utf8))
                        body.append(Data("Content-Type: \(mimeTypeLocal)\r\n\r\n".utf8))
                        body.append(data)
                        body.append(Data("\r\n".utf8))
                    }
                }
            } else {
                if let data = value as? Data {
                    let mimeTypeLocal = mimeType(for: data)
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(value)\"\r\n".utf8))
                    body.append(Data("Content-Type: \(mimeTypeLocal)\r\n\r\n".utf8))
                    body.append(data)
                    body.append(Data("\r\n".utf8))
                } else {
                    body.append(Data("--\(boundary)\r\n".utf8))
                    body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
                    body.append(Data("\(value)\r\n".utf8))
                }
            }
        }
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body as Data
    }
    
    fileprivate func mimeType(for data: Data) -> String {
        var b: UInt8 = 0
        data.copyBytes(to: &b, count: 1)
        switch b {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x4D, 0x49:
            return "image/tiff"
        case 0x25:
            return "application/pdf"
        case 0xD0:
            return "application/vnd"
        case 0x46:
            return "text/plain"
        default:
            return "application/octet-stream"
        }
    }
}
