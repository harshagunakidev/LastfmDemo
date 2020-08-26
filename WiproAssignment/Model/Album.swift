//
//  Album.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

struct ResultResponse: Codable {
    var results: AlbumSearchResponse?
    var album: Album?
    var topalbums: AlbumResponse?
}

// MARK: - AlbumSearchResponse
struct AlbumSearchResponse: Codable {
    var opensearchQuery: OpensearchQuery?
    var opensearchTotalResults, opensearchStartIndex, opensearchItemsPerPage: String?
    var albummatches: Albummatches?
    var attr: Attr?

    enum CodingKeys: String, CodingKey {
        case opensearchQuery = "opensearch:Query"
        case opensearchTotalResults = "opensearch:totalResults"
        case opensearchStartIndex = "opensearch:startIndex"
        case opensearchItemsPerPage = "opensearch:itemsPerPage"
        case albummatches
        case attr = "@attr"
    }
}

// MARK: - Albummatches
struct Albummatches: Codable {
    var album: [Album]?
}

// MARK: - Album
struct Album: Codable {
    var name, artist: String?
    var url: String?
    var image: [Image]?
    var wiki: Wiki?
        
    func getImage(size: Size) -> String {
        return image?.filter({ $0.size == size.rawValue }).first?.text ?? ""
    }
}

// MARK: - Image
struct Image: Codable {
    var text: String?
    var size: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

enum Size: String, Codable {
    case extralarge = "extralarge"
    case large = "large"
    case medium = "medium"
    case small = "small"
    case mega = "mega"
}

// MARK: - Attr
struct Attr: Codable {
    var attrFor: String?

    enum CodingKeys: String, CodingKey {
        case attrFor = "for"
    }
}

// MARK: - OpensearchQuery
struct OpensearchQuery: Codable {
    var text, role, searchTerms, startPage: String?

    enum CodingKeys: String, CodingKey {
        case text = "#text"
        case role, searchTerms, startPage
    }
}
// MARK: - Wiki
struct Wiki: Codable {
    var published, summary, content: String?
}

// MARK: - Artist
struct Artist: Codable {
    let url: String
    let name, mbid: String
}

struct AlbumResponse: Codable {
    var album: [TopAlbum]?
}

// MARK: - Album
struct TopAlbum: Codable {
    var artist: Artist?
    var image: [Image]?
    var playcount: String?
    var url: String?
    var name, mbid: String?

    enum CodingKeys: String, CodingKey {
        case artist
        case image, playcount, url, name, mbid
    }
    func getImage(size: Size) -> String {
         return image?.filter({ $0.size == size.rawValue }).first?.text ?? ""
     }
}

extension Album: Equatable {
  static func == (lhs: Album, rhs: Album) -> Bool {
    return lhs.name == rhs.name &&
    lhs.artist == rhs.artist &&
    lhs.url == rhs.url
  }
}

