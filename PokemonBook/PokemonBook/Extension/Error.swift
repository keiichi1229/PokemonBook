//
//  Error.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import Foundation

extension Error {
    var msg: String {
        return (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}
