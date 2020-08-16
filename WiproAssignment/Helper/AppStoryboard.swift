//
//  AppStoryboard.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

enum AppStoryboard : String {
    case Main = "Main"
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewcontrollerClass: T.Type) -> T {
        let storyBoardId =  (viewcontrollerClass as UIViewController.Type).storyboardID
        let controller = instance.instantiateViewController(withIdentifier: storyBoardId) as! T
        return controller
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateFromAppStoryBoard(appStoryBoard: AppStoryboard) -> Self {
        return appStoryBoard.viewController(viewcontrollerClass: self)
    }
    
    
}
