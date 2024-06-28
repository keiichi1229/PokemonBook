//
//  PokemonBookCoordinator.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import UIKit

protocol PokemonBookRouteDelegate: AnyObject  {
    func gotoPokemonDetail(pId: String)
}

class PokemonBookCoordinator: NSObject {
    private weak var rootNavigationController: UINavigationController?
    init(_ navCtrl: UINavigationController?) {
        rootNavigationController = navCtrl
    }
}

extension PokemonBookCoordinator: PokemonBookRouteDelegate {
    func gotoPokemonDetail(pId: String) {
        // move to first
        if var controllers = rootNavigationController?.viewControllers {
            if controllers.count > 1 {
                controllers.removeLast()
            }
            
            let view = PokemonDetailViewController(pId: pId)
            view.coordinator = self
            controllers.append(view)
            rootNavigationController?.setViewControllers(controllers, animated: true)
        }
    }
}
