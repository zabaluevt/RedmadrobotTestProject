//
//  CollectionsViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 09.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import UIKit

class CollectionsViewController: UICollectionViewController {
    private var collections = [CollectionsModel]()
    private var page = 1
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        makeRequest(page: page)
    }
    
    fileprivate func initCollectionView() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = .black
    }
    
    // TODO: - Подумать как вынести в общий файл
    fileprivate func renderPhotos(_ photosResults: [CollectionsModel]) {
        if (photosResults.isEmpty) { return }
        
        var i = 0
        
        repeat {
            self.collections.append(photosResults[i])
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: [IndexPath(item: self.collections.count - 1, section: 0)])
            }, completion: nil)
            
            i += 1
        } while i < photosResults.count
    }
    
    fileprivate func makeRequest(page: Int) {
        Network.get(
            type: [CollectionsModel].self,
            urlParams: "/collections",
            queryParams: ["page" : String(page), "per_page": String(15)],
            completHandler: { response in
                self.renderPhotos(response)
        },
            errorHandler: { error in
                Alert.show(self)
        }
        )
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        guard let uri = collections[indexPath.row].cover_photo?.urls?.small, let url = URL(string: uri) else { return cell }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.photo = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photosUrl = collections[indexPath.row].links?.photos else { return }
        
        let vc = BrowseCollectionViewController()
        vc.photosUrl = photosUrl
        
        self.present(vc, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == collections.count - 1 ) {
            page += 1
            makeRequest(page: page)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CollectionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let ratio = CGFloat((collections[sizeForItemAt.row].cover_photo?.width!)!) / (UIScreen.main.bounds.width - Settings.numberOfColumns * 8) * Settings.numberOfColumns
        let width = CGFloat((collections[sizeForItemAt.row].cover_photo?.width!)!) / ratio
        let height = CGFloat((collections[sizeForItemAt.row].cover_photo?.height!)!) / ratio
        return CGSize(width: width, height: height)
    }
}
