//
//  MainCoordinator.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var shouldShowTopAlbums: Bool = false
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = AlbumSearchViewController.instantiateFromAppStoryBoard(appStoryBoard: .Main)
        controller.didSearchAlbum = {
            [weak self] (text) in
            self?.showSearchAlbums(searchText: text)
        }
        controller.onClickAlbum = {
            [weak self](name, artist) in
            self?.showAlbumDetail(name: name, artist: artist)
        }
        navigationController.pushViewController(controller, animated: true)
    }
}

extension MainCoordinator {
    func showSearchAlbums(searchText: String?) {
        let child = AlbumSearchResultCoordinator(navigationController: navigationController)
        child.searchViewModel = AlbumSearchViewModel(searchTerm: searchText ?? "")
        childCoordinators.append(child)
        child.start()
    }
    
    func showAlbumDetail(name: String, artist: String) {
         let child = AlbumDetailCoordinator(navigationController: navigationController)
         child.albumDetailViewModel = AlbumDetailViewModel(album: name, artist:  artist)
         childCoordinators.append(child)
         child.start()
     }
    
    func childDidFinish(child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child { childCoordinators.remove(at: index); break }
        }
    }
    
    
}
