//
//  CollectionViewCell.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 06.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
//    private let badge: UIView = {
//        let badge = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        badge.backgroundColor = .red
//        badge.layer.cornerRadius = 10.0
//        badge.layer.borderColor = UIColor.green.cgColor
//        badge.layer.borderWidth = 10
//
//        badge.translatesAutoresizingMaskIntoConstraints = false
//        return badge
//    }()
    
    public var photo: UIImage? {
        didSet {
            guard photo != nil else { return }
            imageView.image = photo
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageView()
//        initBadges()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    fileprivate func initImageView() {
        addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
//    fileprivate func initBadges() {
//        addSubview(badge)
//        badge.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
//        badge.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10).isActive = true
//    }
}
