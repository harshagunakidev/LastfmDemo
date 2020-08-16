//
//  ResponseParser.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(APIError)
}

