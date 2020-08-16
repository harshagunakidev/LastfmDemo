//
//  SessionManager.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

struct BaseURL {
    static let urlString: String = "http://ws.audioscrobbler.com/2.0"
}

enum HTTPMethod: String {
    case get, put, post, delete
    var type: String { return self.rawValue.uppercased() }
}

typealias CompletionHandler<T> = ((Result<T>) -> Void)

class SessionManager {
    let reachabilty = Reachability()
    var defaultSession: URLSession { return URLSession(configuration: defaultSessionConfiguration) }
    static let timoutInterval: Double = 60.0
    static let `shared` = SessionManager()
    private init() { }
    
    private lazy var defaultSessionConfiguration : URLSessionConfiguration = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = SessionManager.timoutInterval
        configuration.timeoutIntervalForResource = SessionManager.timoutInterval
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.waitsForConnectivity = true
        configuration.isDiscretionary = true
        configuration.httpCookieAcceptPolicy = .always
        return configuration
    }()
}

extension SessionManager {
    func requestModel<T: Codable>(request: URLRequest, _ completionHandler: @escaping CompletionHandler<T>) {
        if !reachabilty.isConnectedToNetwork() {
            completionHandler(.error(APIError(type: .clientError(.noInternetConnection))))
        }
        self.dataTask(withRequest: request) { (result: Result<T>) in
            switch result {
            case .success(let data):
                completionHandler(Result.success(data))
            case .error(let error):
                completionHandler(Result.error(error))
            }
        }
    }
}


fileprivate extension SessionManager {
    func dataTask<T: Codable>(withRequest request: URLRequest,  completion: @escaping CompletionHandler<T>) {
        self.defaultSession.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completion(.error(APIError(type: .clientError(.invalidURL))))
                return
            }
            guard let theData = data else {
                completion(.error(APIError(type: .clientError(.nilResponse))))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                completion(.error(APIError(type: .clientError(.nilResponse))))
                return
            }
            if let urlResponse = response as? HTTPURLResponse{
                let responseStatusCode = urlResponse.statusCode
                switch responseStatusCode {
                case (200..<300):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let parsedResponse = try decoder.decode(T.self, from: theData)
                        if responseStatusCode == 200 {
                            completion(Result.success(parsedResponse))
                        } else {
                            completion(.error(APIError(type: .clientError(.nilResponse), code: -555 )))
                        }
                    } catch {
                        completion(.error(APIError(type: .clientError(.jsonParsingError))))
                    }
                case 400:
                    completion(.error(APIError(type: .serverError(.badRequest), code: responseStatusCode)))
                case 401:
                    completion(.error(APIError(type: .serverError(.unauthorized), code: responseStatusCode)))
                case 403:
                    completion(.error(APIError(type: .serverError(.forbidden), code: responseStatusCode)))
                case 404:
                    completion(.error(APIError(type: .serverError(.notFound), code: responseStatusCode)))
                    
                case 500:
                    completion(.error(APIError(type: .serverError(.internalServerError), code: responseStatusCode)))
                case 501:
                    completion(.error(APIError(type: .serverError(.notImplemented), code: responseStatusCode)))
                case 502:
                    completion(.error(APIError(type: .serverError(.badGateway), code: responseStatusCode)))
                case 503:
                    completion(.error(APIError(type: .serverError(.serviceUnavailable), code: responseStatusCode)))
                case 504:
                    completion(.error(APIError(type: .serverError(.gatewayTimeout), code: responseStatusCode)))
                default:
                    completion(.error(APIError(type: .serverError(.unknownError), code: responseStatusCode)))
                }
            }
         }.resume()
    }
}
