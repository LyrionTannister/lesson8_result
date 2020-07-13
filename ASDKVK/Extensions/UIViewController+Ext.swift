//
//  UIViewController+Ext.swift
//  Geekbrains Weather
//
//  Created by user on 16/01/2019.
//  Copyright © 2019 Andrey Antropov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(error: Error) {
        let alertVC = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
