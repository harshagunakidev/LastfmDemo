//
//  AlbumDetailViewModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

class AlbumDetailViewModel {
    private(set) var album: Album?
    
    private let sessionManager: SessionManager
    private var albumName: String
    private var artist: String
    
    init(album: String,artist: String, sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
        self.albumName = album
        self.artist = artist
    }
    
    func getAlbumInfo(_ completionHandler: @escaping CompletionHandler<ResultResponse>) {
        let request = APIRouter.albumGetInfo(artist: artist, album: albumName).urlRequest
        sessionManager.requestModel(request: request) { [weak self] (response: Result<ResultResponse>) in
            switch response {
            case .success(let data):
                self?.album = data.album
                completionHandler(Result.success(data))
            case .error(let error): completionHandler(Result.error(error))
            }
        }
    }
}






