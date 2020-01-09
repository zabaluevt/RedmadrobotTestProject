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
    private var searchedText = ""
    private var numberOfColumns: CGFloat = 2
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
    
    func setupCollectionView() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        //        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewIdentifier")
        //        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 40, right: 16)
        //        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        
    }
    
    func makeRequest(searchText: String, isNewPage: Bool = false) {
        page = isNewPage ? page + 1 : 1
        
        Network.get(
            type: ImagesModel.self,
            urlParams: "/search/photos",
            queryParams: ["query": searchText, "page": String(page), "per_page": String(15)],
            completHandler: { response in
                if isNewPage {
                    self.photos += response.results ?? []
                    self.collectionView.reloadData()
                } else {
                    self.photos = response.results ?? []
                    self.collectionView.reloadData()
                    self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
        },
            errorHandler: { error in
                let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        })
    }
    
    func openImageForFullScreen(index: Int) {
        guard let uri = photos[index].urls?.regular else { return }
        guard let url = URL(string: uri) else { return }
        
        let newImageView = UIImageView()
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    newImageView.image = UIImage(data: data)
                }
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
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
        
        guard let data = try? Data(contentsOf: URL(string: urlKey)!) else { return cell }
        
        cell.photo = UIImage(data: data)
        
        return cell
    }
}

// MARK: UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { (_) in
            guard searchText != "" else { return }
            self.searchedText = searchText
            self.makeRequest(searchText: searchText)
        })
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    internal func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let ratio = CGFloat(photos[sizeForItemAt.row].width!) / (UIScreen.main.bounds.width - numberOfColumns * 8) * numberOfColumns
        let width = CGFloat(photos[sizeForItemAt.row].width!) / ratio
        let height = CGFloat(photos[sizeForItemAt.row].height!) / ratio
        
        return CGSize(width: width, height: height)
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //           return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    //       }
    //
}



