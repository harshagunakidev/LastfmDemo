//
//  APIRouter.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

enum APIRouter {
    private var baseUrl: String { return BaseURL.urlString }

    case searchAlbum(name: String,page: Int, pageSize: Int)
    case albumGetInfo(artist: String, album: String)
    case getTopAlbums
}

struct APIClient {
    static let key = "b036f4277e8d3d6432c453d15a19173f"
}

extension APIRouter {
    var httpMethod: HTTPMethod { switch self { case .searchAlbum, .albumGetInfo, .getTopAlbums: return .get } }
    
    var headers: [String: String] {
        return [:]
    }
    
    var body: Data? {
        switch self {
        case .searchAlbum, .albumGetInfo, .getTopAlbums: return nil
        }
    }
    
    var parameters: [String: String] {
        var parameters = [String: String]()
        switch self {
        case .searchAlbum(let name, let page, let pageSize):
            parameters["method"] = "album.search"
            parameters["album"] = name
            parameters["page"] = page.description
            parameters["limit"] = pageSize.description
        case .albumGetInfo(let artist,let album):
            parameters["method"] = "album.getinfo"
            parameters["album"] = album
            parameters["artist"] = artist
        case .getTopAlbums:
            parameters["method"] = "user.gettopalbums"
            parameters["user"] = "rj"
        }
        parameters["api_key"] = APIClient.key
        parameters["format"] = "json"
        return parameters
    }
    
    var path: String {
        switch self { case .searchAlbum, .albumGetInfo, .getTopAlbums: return "/2.0/" }
    }
}

extension APIRouter {
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = path
        urlComponents?.queryItems = APIRouter.queryItems(parameters)
        guard let url = urlComponents?.url else { preconditionFailure("Failed to construct URL") }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: SessionManager.timoutInterval)
        request.httpMethod = httpMethod.type
        for (key, value) in headers { request.setValue(value, forHTTPHeaderField: key) }
        request.httpBody = body
        return request
    }
}

extension APIRouter {
    static func queryItems(_ parameters : [String : String]) -> [URLQueryItem] {
        return parameters.map { URLQueryItem(name: $0, value: $1)}
    }
}

extension Dictionary {
    var json:String? {
        var jsonString: String?
        do {
            if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
                jsonString = String(data: theJSONData, encoding: .utf8)
            }
        }
        return jsonString
    }
}
