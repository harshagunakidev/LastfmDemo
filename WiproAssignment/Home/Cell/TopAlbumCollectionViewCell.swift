//
//  TopAlbumCollectionViewCell.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 24/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class TopAlbumCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(withViewModel viewModel: AlbumRepresentableProtocol) {
        titleLabel.text = viewModel.name
        imageView.loadImage(urlString: viewModel.imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = ""
    }
}
