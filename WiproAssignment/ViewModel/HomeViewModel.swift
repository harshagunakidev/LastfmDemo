//
//  HomeViewModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 24/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class HomeViewModel {
    private let sessionManager: SessionManager
    private(set) var topResults: [TopAlbum]?

    init(sessionManager: SessionManager = SessionManager.shared) {
        self.sessionManager = sessionManager
    }
    
    func getTopAlbums(_ completionHandler: @escaping CompletionHandler<ResultResponse>) {
        let request = APIRouter.getTopAlbums.urlRequest
        sessionManager.requestModel(request: request) { [weak self](response: Result<ResultResponse>) in
            switch response {
            case .success(let data):
                self?.topResults = data.topalbums?.album
                completionHandler(Result.success(data))
            case .error(let error): completionHandler(Result.error(error))
            }
        }
    }
}
