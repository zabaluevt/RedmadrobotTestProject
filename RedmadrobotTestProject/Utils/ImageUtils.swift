//
//  OpenFullScreenImage.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 10.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import UIKit

class ImageUtils {
    static var viewController: UIViewController? = nil

    static func open(vc: UIViewController, uri: String) {
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
        
        vc.view.addSubview(newImageView)
        vc.navigationController?.isNavigationBarHidden = true
        vc.tabBarController?.tabBar.isHidden = true
        
        // TODO: - Костыль
        viewController = vc
    }

    @objc static func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
         ImageUtils.viewController?.navigationController?.isNavigationBarHidden = false
         ImageUtils.viewController?.tabBarController?.tabBar.isHidden = false
         sender.view?.removeFromSuperview()
    }
}
