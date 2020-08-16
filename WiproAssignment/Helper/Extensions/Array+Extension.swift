//
//  Array+Extension.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
