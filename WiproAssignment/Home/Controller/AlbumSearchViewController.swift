//
//  AlbumSearchViewController.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 15/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import UIKit

let headerId = "headerId"

class AlbumSearchViewController: UIViewController {
    var didSearchAlbum: ((_ name: String?) -> Void)?
    var onClickAlbum: ((_ name: String, _ artist: String) -> Void)?
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = self.view.center
        activityView.hidesWhenStopped = true
        activityView.color = .black
        return activityView
    }()
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.hidesNavigationBarDuringPresentation = false
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.tintColor = .black
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        searchVC.searchBar.delegate = self
        return searchVC
    }()
    let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Top Albums"
        self.navigationItem.titleView = searchController.searchBar
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.view.addSubview(activityIndicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTopAlbum()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    func getTopAlbum() {
          activityIndicator.startAnimating()
          viewModel.getTopAlbums({ [weak self](result) in
              DispatchQueue.main.async {
                  self?.activityIndicator.stopAnimating()
              }
              switch result {
              case .success:
                  DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                  }
              case .error(let error):
                  self?.showAlert(title: "Error", message: error.message, style: .alert, actions: [])
              }
          })
      }
}

extension AlbumSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

extension AlbumSearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didSearchAlbum?(searchBar.text)
    }
}

extension AlbumSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return viewModel.topResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell
        let album = viewModel.topResults?[safe: indexPath.row]
        let viewModel = AlbumListCellViewModel(name: album?.name ?? "", artist: album?.artist?.name ?? "", imageURL: album?.getImage(size: .large) ?? "")
        guard let theCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TopAlbumCollectionViewCell.self), for: indexPath) as? TopAlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        theCell.configure(withViewModel: viewModel)
        cell = theCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        let label = UILabel()
        label.text = "Top Albums"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        header.backgroundColor = .black
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: header.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        return header
    }
}

extension AlbumSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 2, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = viewModel.topResults?[safe: indexPath.row]
        onClickAlbum?(album?.name ?? "", album?.artist?.name ?? "")
    }

}
