//
//  ViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 16.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let imageUrl: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRequest()
    }
    
    func renderPhoto(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        print(imageUrl)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageView.contentMode = .scaleAspectFit
        
        let queue = DispatchQueue.global(qos: .utility)
           queue.async{
               if let data = try? Data(contentsOf: url){
                   DispatchQueue.main.async {
                       imageView.image = UIImage(data: data)

                   }
               }
           }
        
        view.addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    func makeRequest() {
        Network.get(
            type: RandomPhotoModel.self,
            urlParams: "/photos/random",
            queryParams: [:],
            completHandler: { response in
                guard let uri = response.urls?.regular else { return }
                self.renderPhoto(imageUrl: uri)
            },
            errorHandler: { error in
                let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        )
    }
}

