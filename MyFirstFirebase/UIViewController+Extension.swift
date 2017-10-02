//
//  UIViewController+Extension.swift
//  MyFirstFirebase
//
//  Created by Ahmed on 8/15/17.
//  Copyright © 2017 Ahmed. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, okTitle: String = "OK", okHandler: ((UIAlertAction)->Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: okHandler))
        self.present(alert, animated: true, completion: nil)
    }
}
