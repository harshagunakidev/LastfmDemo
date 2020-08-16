//
//  AlbumListTableViewCell.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumListTableViewCell: UITableViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    func configure(withViewModel viewModel: AlbumRepresentableProtocol) {
        titleLabel.text = viewModel.name
        subtitle.text = viewModel.artist
        albumImageView.loadImage(urlString: viewModel.imageURL)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumImageView.image = nil
        titleLabel.text = ""
        subtitle.text = ""
    }
}
