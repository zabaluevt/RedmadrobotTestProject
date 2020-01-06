//
//  PhotosCollectionViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 30.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timer: Timer?
    private var photos = [Results]()
    private var filteredPhotos = [Results]()
    private var numberOfColumns: CGFloat = 2
    private var page: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        makeRequest()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
    }
    
    func setupCollectionView() {
//        collectionView.backgroundColor = .black
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewIdentifier")
//        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 40, right: 16)
//        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        
    }
    
    func makeRequest() {
        page += 1
        Network.get(
            urlParams: "/search/photos",
            queryParams: ["query": "home", "page": String(page), "per_page": String(15)],
            completHandler: { response in
                self.photos += response.results ?? []
                self.collectionView.reloadData()
            },
            errorHandler: { error in
                let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        )
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    // MARK: - UICollectionViewDataSource, UIColectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photos.count - 1 ) {
            makeRequest()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uri = photos[indexPath.row].urls?.regular else { return }
        guard let url = URL(string: uri) else { return }
        
        // TODO: - Добавить лоудер пока загружается фото
        guard let data = try? Data(contentsOf: url) else { return }
        
        let newImageView = UIImageView(image: UIImage(data: data))
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        guard !self.photos.isEmpty, let urlKey = self.photos[indexPath.row].urls?.thumb else { return cell }
        
        if let url = URL(string: urlKey) {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                let imageView = UIImageView(image: image)
                
                imageView.layer.cornerRadius = 5.0
                imageView.clipsToBounds = true
                
                imageView.center = CGPoint(x: cell.frame.size.width / 2,
                y: cell.frame.size.height / 2)
                
                cell.contentView.addSubview(imageView)
            } catch _ {}
        }
        return cell
    }
}

// MARK: UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        
        // отступы по 8 с каждой стороны
        let screenWidth = UIScreen.main.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right - ((numberOfColumns - 1) * 16)
        return CGSize(width: screenWidth / numberOfColumns, height: screenWidth / numberOfColumns)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//           return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//       }
}


