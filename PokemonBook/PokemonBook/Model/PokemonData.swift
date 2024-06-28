//
//  PokemonData.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import SwiftyJSON
import UIKit

struct PokemonEntry {
    var name: String
    var url: String
    
    init(_ json: JSON) {
        name = json["name"].stringValue
        url = json["url"].stringValue
    }
}

struct PokemonType {
    var slot: Int
    var type: PokemonTypeName
    init(_ json: JSON) {
        slot = json["slot"].intValue
        type = PokemonTypeName(json["type"])
    }
}

struct PokemonTypeName {
    var name: String
    var url: String
    init(_ json: JSON) {
        name = json["name"].stringValue
        url = json["url"].stringValue
    }
}

struct PokemonData: Codable {
    var id: String
    var name: String
    var imgUrl: String
    var types: String
    var evoChain: [String] = []
    var flavorTextTable: [String:String] = [:]
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        imgUrl = json["sprites"].dictionaryValue["front_default"]?.stringValue ?? ""
        types = json["types"].arrayValue.map { PokemonType($0).type.name }.joined(separator: " ")
    }
    
    mutating func updateDefaultInfo(pokemon: PokemonData) {
        id = pokemon.id
        name = pokemon.name
        imgUrl = pokemon.imgUrl
        types = pokemon.types
    }
    
    mutating func updateFlavorTextTable(_ table: [String:String]) {
        flavorTextTable = table
    }
    
    mutating func updateEvolutionChainIds(_ chain: [String]) {
        evoChain = chain
    }
}
