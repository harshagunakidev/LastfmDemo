//
//  AlbumDetailViewController.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {
    @IBOutlet weak var contentHolderView: UIView!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    var albumDetailViewModel: AlbumDetailViewModel?
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.color = .black
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAlbum()
    }
    
    func getAlbum() {
        activityIndicator.startAnimating()
        albumDetailViewModel?.getAlbumInfo({ [weak self] (result) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.configureUI()
                }
            case .error(let error):
                self?.showAlert(title: "Error", message: error.message, style: .alert, actions: [])
            }
        })
    }
    
    private func configureUI() {
        guard let uwAlbumDetailViewModel = albumDetailViewModel else {
            return
        }
        self.titleLabel.text = uwAlbumDetailViewModel.album?.name ?? ""
        self.artistLabel.text = uwAlbumDetailViewModel.album?.artist ?? ""
        self.publishDateLabel.text = uwAlbumDetailViewModel.album?.wiki?.published ?? ""
        self.summaryLabel.text = uwAlbumDetailViewModel.album?.wiki?.summary ?? ""
        self.albumImageView.loadImage(urlString: uwAlbumDetailViewModel.album?.getImage(size: .mega) ?? "")
    }
}
