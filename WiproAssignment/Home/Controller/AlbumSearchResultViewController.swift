//
//  AlbumSearchResultViewController.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

class AlbumSearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var searchViewModel: AlbumSearchViewModel?
    var onSelectAlbum: ((AlbumListCellViewModel) -> Void)?

    var didClickSearch: (() -> Void)?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.color = .black
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setTitle(title: searchViewModel?.searchTerm ?? "", subtitle: "")
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItems = [search]
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchAlbum()
     
    }
    
    @objc func searchTapped() {
       didClickSearch?()
    }
}

extension AlbumSearchResultViewController {
    
    func searchAlbum() {
          activityIndicator.startAnimating()
          searchViewModel?.searchAlbum({ [weak self](result) in
              DispatchQueue.main.async {
                  self?.activityIndicator.stopAnimating()
              }
              switch result {
              case .success:
                  DispatchQueue.main.async {
                      self?.updateUI()
                      self?.tableView.reloadData()
                  }
              case .error(let error):
                  self?.showAlert(title: "Error", message: error.message, style: .alert, actions: [])
              }
          })
      }
}

extension AlbumSearchResultViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel?.searchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let theCell = tableView.dequeueReusableCell(withIdentifier: AlbumListTableViewCell.identifier, for: indexPath) as? AlbumListTableViewCell else { return UITableViewCell() }
        
        let album = searchViewModel?.searchResult?[safe: indexPath.row]
        let viewModel = AlbumListCellViewModel(name: album?.name ?? "", artist: album?.artist ?? "", imageURL: album?.getImage(size: .extralarge) ?? "")
        theCell.configure(withViewModel: viewModel)
        return theCell
    }
}

extension AlbumSearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = searchViewModel?.searchResult?[safe: indexPath.row]
        let viewModel = AlbumListCellViewModel(name: album?.name ?? "", artist: album?.artist ?? "", imageURL: album?.getImage(size: .extralarge) ?? "")
        onSelectAlbum?(viewModel)
    }
}

extension AlbumSearchResultViewController {
    func updateUI() {
        guard let result = searchViewModel?.searchResult else { return }
        navigationItem.setTitle(title: searchViewModel?.searchTerm ?? "", subtitle: "\(result.count) search results")
    }
}
