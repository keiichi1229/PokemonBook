//
//  UINavigationController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import UIKit

extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
          popToViewController(vc, animated: animated)
        }
    }
    
    func setAsWhite() {
        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = .default
        if #available(iOS 13, *) {
            self.navigationBar.barTintColor = .white.resolvedColor(with: traitCollection)
        } else {
            self.navigationBar.barTintColor = .white
        }
        
        if #available(iOS 15, *) {
            self.navigationBar.backgroundColor = .white
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            navigationBarAppearance.backgroundColor = .white
            navigationBarAppearance.shadowColor = .clear

            navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationBar.standardAppearance = navigationBarAppearance
            navigationBar.compactAppearance = navigationBarAppearance
        }
    }
}
