//
//  UIViewController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, message: String?, callback: (()->Void)?) {
        let alertViewCtrl = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            callback?()
        }
        alertViewCtrl.addAction(okAction)
        
        self.present(alertViewCtrl, animated: true, completion: nil)
    }
}
