//
//  AlbumListCellViewModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

protocol AlbumRepresentableProtocol {
    var name: String { get }
    var artist: String { get }
    var imageURL: String { get }
}

struct AlbumListCellViewModel: AlbumRepresentableProtocol {
    var name: String
    var artist: String
    var imageURL: String
}
