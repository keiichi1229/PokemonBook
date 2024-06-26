//
//  String.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/25.
//

import Foundation

extension String {
    func formatToTag() -> String {
        guard let number = Int(self) else {
            return "####"
        }
        return String(format: "#%04d", number)
    }
}
