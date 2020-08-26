//
//  APIError.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

struct APIError {
    let type: APIErrorType
    var code: Int
    var message: String
    
    init(type: APIErrorType, code: Int? = nil, message: String? = nil) {
        self.type = type
        self.code = code ?? -555 //Default error code
        self.message = message ?? type.errorMessage
    }
}

enum APIErrorType {
    internal enum ClientErrorType {
        case invalidURL //Error returned by URLSession
        case jsonParsingError //Error in parsing the response, catch block of JSONSerialization
        case nilRequest //URLRequest is nil
        case nilResponse // Response after parsing (feed) is nil
        case insufficientData //If body doesn't contain all the required data
        case noInternetConnection //If body doesn't contain all the required data
        var errorMessage: String {
            let text: String
            switch self {
            case .invalidURL: text = "The URL is invalid"
            case .jsonParsingError: text = "Error in parsing response JSON"
            case .nilRequest: text = "URL Request is nil"
            case .nilResponse: text = "URL Response/data is nil"
            case .insufficientData: text = "Insufficent data for request body"
            case .noInternetConnection: text = "No Internet Connection"
            }
            return text
        }
    }
    
    internal enum ServerErrorType {
        case badRequest //400
        case unauthorized //401
        case forbidden //403 - Device limit exceeded
        case notFound //404
        case internalServerError //500
        case notImplemented //501
        case badGateway //502
        case serviceUnavailable //503
        case gatewayTimeout //504
        case unknownError //Unknown Error
        var errorMessage: String {
            let text: String
            switch self {
            case .badRequest: text = "Bad Request"
            case .unauthorized: text = "Unauthorized"
            case .forbidden: text = "Forbidden"
            case .notFound: text = "Server not found"
            case .internalServerError: text  = "Internal Server Error"
            case .notImplemented: text = "Not implemented"
            case .badGateway: text = "Bad Gateway"
            case .serviceUnavailable: text = "Service Unavailable"
            case .gatewayTimeout: text = "Gateway Timeout"
            case .unknownError: text = "Unknown error"
            }
            return text
        }
    }
    case clientError(ClientErrorType)
    case serverError(ServerErrorType)
    var errorMessage: String {
        let text: String
        switch self {
        case .clientError(let clientErrorType): text = clientErrorType.errorMessage
        case .serverError(let serverErrorType): text = serverErrorType.errorMessage
        }
        return text
    }
}
