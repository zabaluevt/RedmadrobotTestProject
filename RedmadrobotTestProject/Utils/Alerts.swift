//
//  Alerts.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 10.01.2020.
//  Copyright © 2020 Тимофей Забалуев. All rights reserved.
//

import UIKit

struct Alert {
    static func show(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка получения данных с сервера, попробуйте позже.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
