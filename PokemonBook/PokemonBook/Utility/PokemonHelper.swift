//
//  PokemonHelper.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import Foundation

class PokemonHelper {
    static let shared = PokemonHelper()
    
    func parseUrlToPokemonId(urlString :String) -> String {
        if let url = URL(string: urlString), let lastPathComponent = url.pathComponents.last {
            let idString = lastPathComponent.replacingOccurrences(of: "/", with: "")
            return idString
        } else {
            return ""
        }
    }
    
    func colorizedPokemonTypes(_ typesString: String) -> NSAttributedString {
        guard !typesString.isEmpty else {
            return NSAttributedString(string: "")
        }
        
        let types = typesString.components(separatedBy: " ")
        let attributedString = NSMutableAttributedString()

        for (index, type) in types.enumerated() {
            guard let pokemonType = PokemonTypeColor(rawValue: type.lowercased()) else {
                continue
            }

            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: pokemonType.color()
            ]

            let typeString = NSAttributedString(string: type.capitalized, attributes: attributes)
            attributedString.append(typeString)

            // Add a space between types, but not after the last one
            if index < types.count - 1 {
                attributedString.append(NSAttributedString(string: " "))
            }
        }

        return attributedString
    }
}
