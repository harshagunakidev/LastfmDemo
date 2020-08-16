//
//  UIImageView+Extension.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    func loadImage(urlString: String) {
        sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "placeholder"))
    }
    
}
