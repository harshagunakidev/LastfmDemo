//
//  AlbumDetailCoordinator.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumDetailCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var albumDetailViewModel: AlbumDetailViewModel?
    
    weak var mainCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = AlbumDetailViewController.instantiateFromAppStoryBoard(appStoryBoard: .Main)
        controller.albumDetailViewModel = albumDetailViewModel
        navigationController.pushViewController(controller, animated: true)
    }
}
