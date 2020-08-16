//
//  AlbumSearchViewModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumSearchViewModel: NSObject {
    private(set) var searchTerm: String?
    private(set) var searchResult: [Album]?
    
    private let sessionManager: SessionManager
    
    init(searchTerm: String?, sessionManager: SessionManager = SessionManager.shared) {
        self.searchTerm = searchTerm
        self.sessionManager = sessionManager
    }
    
    func searchAlbum(_ completionHandler: @escaping CompletionHandler<ResultResponse>) {
        guard let theSearchString = searchTerm, !theSearchString.trimmingCharacters(in: .whitespaces).isEmpty else { completionHandler(Result.error(.init(type: .clientError(.insufficientData)))); return }
        
        let request = APIRouter.searchAlbum(name: theSearchString).urlRequest
        sessionManager.requestModel(request: request) { [weak self] (response: Result<ResultResponse>) in
            switch response {
            case .success(let data):
                self?.searchResult = data.results?.albummatches.album
                completionHandler(Result.success(data))
            case .error(let error): completionHandler(Result.error(error))
            }
        }
    }
}
