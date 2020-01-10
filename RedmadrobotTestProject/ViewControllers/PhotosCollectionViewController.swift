//
//  PhotosCollectionViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 30.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    private var timer: Timer?
    private var photos = [Results]()
    private var searchedText = ""
    private var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView.backgroundColor = .black
    }
    
    // TODO: - Подумать как вынести в общий файл
    fileprivate func renderPhotos(_ photosResults: [Results]) {
        if (photosResults.isEmpty) { return }
        
        var i = 0
        
        repeat {
            self.photos.append(photosResults[i])
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: [IndexPath(item: self.photos.count - 1, section: 0)])
            }, completion: nil)
            
            i += 1
        } while i < photosResults.count
    }
    
    fileprivate func makeRequest(searchText: String, isNewPage: Bool = false) {
        page = isNewPage ? page + 1 : 1
        
        Network.get(
            type: ImagesModel.self,
            urlParams: "/search/photos",
            queryParams: ["query": searchText, "page": String(page), "per_page": String(15)],
            completHandler: { response in
                if isNewPage {
                    guard let photosResults = response.results else { return }
                    self.renderPhotos(photosResults)
                } else {
                    self.photos = response.results ?? []
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
        },
            errorHandler: { error in
                Alert.show(self)
        })
    }
    
    fileprivate func openImageForFullScreen(index: Int) {
        guard let uri = photos[index].urls?.regular else { return }
        ImageUtils.open(vc: self, uri: uri)
    }
    
    // MARK: - UICollectionViewDataSource, UIColectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == photos.count - 1 ) {
            makeRequest(searchText: self.searchedText, isNewPage: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = photos[indexPath.row]
        
        let heightMessage = (item.height != nil) ? "Высота \(item.height!)px\n" : ""
        let widthMessage = (item.width != nil) ? "Ширина \(item.width!)px\n": ""
        let descriptionMessage = (item.description != nil) ? "\(item.description!)" : ""
        let message = heightMessage + widthMessage + descriptionMessage
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        let messageFont = [kCTFontAttributeName: UIFont(name: "Avenir-Roman", size: 18.0)!]
        let messageAttributedString = NSMutableAttributedString(string: message, attributes: messageFont as [NSAttributedString.Key: Any])
        alert.setValue(messageAttributedString, forKey: "attributedMessage")
       
        alert.addAction(UIAlertAction(title: "Открыть картинку", style: UIAlertAction.Style.default, handler: {_ in self.openImageForFullScreen(index: indexPath.row)}))
        alert.addAction(UIAlertAction(title: "Закрыть", style: UIAlertAction.Style.destructive, handler: nil))
               
        self.present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        guard !self.photos.isEmpty, let urlKey = self.photos[indexPath.row].urls?.thumb else { return cell }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: URL(string: urlKey)!) {
                DispatchQueue.main.async {
                    cell.photo = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
}

// MARK: UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.43, repeats: false, block: { (_) in
            guard searchText != "" , let lastChar = searchText.last?.description.lowercased() else { return }
            guard "qwertyuiopasdfghjklzxcvbnm1234567890".contains(lastChar) else { return }
            
            self.searchedText = searchText
            self.makeRequest(searchText: searchText)
        })
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let ratio = CGFloat(photos[sizeForItemAt.row].width!) / (UIScreen.main.bounds.width - Settings.numberOfColumns * 8) * Settings.numberOfColumns
        let width = CGFloat(photos[sizeForItemAt.row].width!) / ratio
        let height = CGFloat(photos[sizeForItemAt.row].height!) / ratio
        
        return CGSize(width: width, height: height)
    }
}



