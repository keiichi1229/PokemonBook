//
//  UIStackView.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import UIKit

extension UIStackView {
    func removeAll() {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
