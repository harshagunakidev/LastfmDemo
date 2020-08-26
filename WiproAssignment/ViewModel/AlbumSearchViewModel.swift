//
//  AlbumSearchViewModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumSearchViewModel: PagingModel {
    private(set) var searchTerm: String
    private let sessionManager: SessionManager
    
    init(searchTerm: String, sessionManager: SessionManager = SessionManager.shared) {
        self.searchTerm = searchTerm
        self.sessionManager = sessionManager
    }
    
    func searchAlbum(_ completionHandler: @escaping CompletionHandler<ResultResponse>) {
        guard isValidSearchString() else { completionHandler(Result.error(.init(type: .clientError(.insufficientData)))); return }
        isFetching = true
        let request = APIRouter.searchAlbum(name: searchTerm, page: page, pageSize: pageSize).urlRequest
        sessionManager.requestModel(request: request) { [weak self] (response: Result<ResultResponse>) in
            self?.isFetching = false
            switch response {
            case .success(let data):
                self?.processResponse(data.results?.albummatches?.album ?? [])
                completionHandler(Result.success(data))
            case .error(let error): completionHandler(Result.error(error))
            }
        }
    }
    
    func isValidSearchString() -> Bool {
        return !searchTerm.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

extension AlbumSearchViewModel {
    func isNextPageAvailable(currentPage: Int) -> Bool {
        let album = objectsArray[safe: currentPage] as? Album
        let lastAlbum = objectsArray.last as? Album
        if album == lastAlbum && canDownload()  {
            page = objectsArray.count
            return true
        }
        return false
    }
}
