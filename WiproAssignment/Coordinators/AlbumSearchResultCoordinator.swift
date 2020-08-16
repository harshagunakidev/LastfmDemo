//
//  AlbumSearchResultCoordinator.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumSearchResultCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var searchViewModel: AlbumSearchViewModel?
    
    weak var mainCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = AlbumSearchResultViewController.instantiateFromAppStoryBoard(appStoryBoard: .Main)
        controller.searchViewModel = searchViewModel
        controller.didClickSearch = {
            [weak self] in
            self?.mainCoordinator?.childDidFinish(child: self)
            self?.navigationController.popViewController(animated: false)
        }
        
        controller.onSelectAlbum = {
           [weak self] (viewModel) in
            self?.showAlbumDetail(viewModel: viewModel)
        }
        navigationController.pushViewController(controller, animated: true)
    }
}

extension AlbumSearchResultCoordinator {
    func showAlbumDetail(viewModel: AlbumListCellViewModel) {
        let child = AlbumDetailCoordinator(navigationController: navigationController)
        child.albumDetailViewModel = AlbumDetailViewModel.init(album: viewModel.name, artist:  viewModel.artist)
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child { childCoordinators.remove(at: index); break }
        }
    }
}
