//
//  ViewController.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 16.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        renderPhoto()
        renderButton()
    }
    
    func renderPhoto() {
        let image = UIImage(named: "redmadrobot.png")
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        view.addSubview(imageView)
    }
    
    func renderButton() {
        let button = UIButton(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
        button.setTitle("Go forward", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(self.pressed), for: .touchDown)
        view.addSubview(button)
    }
    
    @objc func pressed() {
       
    }
}

