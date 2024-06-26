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

struct PokemonData {
    var id: String
    var name: String
    var imgUrl: String
    var type: String
    var evoChain: [String] = []
    var flavorText: [String:String] = [:]
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        imgUrl = json["sprites"].dictionaryValue["front_default"]?.stringValue ?? ""
        type = json["types"].arrayValue.map { PokemonType($0).type.name }.joined(separator: " ")
    }
}
