//
//  UIViewController+Extension.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String , message: String , style: UIAlertController.Style, actions: [UIAlertAction]) {
        let alertViewController = UIAlertController(title: title, message: message , preferredStyle: style)
        let oK = UIAlertAction(title: "OK", style: .default) { (alert) in
        }
        alertViewController.addAction(oK)
        DispatchQueue.main.async {
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}
