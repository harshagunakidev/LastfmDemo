//
//  AppDelegate+Extension.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

extension SceneDelegate {
    func makeSearchAsHomeController(scene: UIWindowScene)  {
        let window = UIWindow(windowScene: scene)
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .black
        mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator?.start()
        window.rootViewController = mainCoordinator?.navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func searchResultCoordinator(navVC: UINavigationController) -> Coordinator {
        return AlbumSearchResultCoordinator.init(navigationController: navVC)
    }
}

