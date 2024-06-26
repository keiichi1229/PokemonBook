//
//  UIApplication.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        // Get connected scenes for iOS 15
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var bottomSafeAreaInset: CGFloat {
        if let windowScene = connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return window.safeAreaInsets.bottom
        }
        return 0
    }
}
