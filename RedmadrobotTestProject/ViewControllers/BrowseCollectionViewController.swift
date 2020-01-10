//
//  BrowseCollectionViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 10.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: UIViewController {
    
    public var photosUrl = ""
    
    fileprivate var items = [Results]()
    fileprivate var page = 1
    fileprivate var collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        makeRequest(page: page)
    }
    
    fileprivate func initCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    // TODO: - Подумать как вынести в общий файл
    fileprivate func renderPhotos(_ photosResults: [Results]) {
        if (photosResults.isEmpty) { return }
        
        var i = 0
        
        repeat {
            self.items.append(photosResults[i])
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: [IndexPath(item: self.items.count - 1, section: 0)])
            }, completion: nil)
            
            i += 1
        } while i < photosResults.count
    }
    
    fileprivate func makeRequest(page: Int) {
        Network.get(
            type: [Results].self,
            url: photosUrl,
            urlParams: "",
            queryParams: ["page" : String(page)],
            completHandler: { response in
                self.renderPhotos(response)
        },
            errorHandler: { error in
                let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
        )
    }
}

extension BrowseCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - 16) / 2
        return CGSize(width: size, height: size)
    }
}

extension BrowseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        guard let uri = items[indexPath.row].urls?.small, let url = URL(string: uri) else { return cell }
        
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    cell.photo = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == items.count - 1) {
            page += 1
            makeRequest(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uri = items[indexPath.row].urls?.regular else { return }
        ImageUtils.open(vc: self, uri: uri)
    }
}
