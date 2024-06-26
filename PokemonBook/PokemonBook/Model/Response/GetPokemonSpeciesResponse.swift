//
//  GetPokemonSpeciesResponse.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import SwiftyJSON

struct GetPokemonSpeciesResponse: BaseResponse {
    var flavorTextTable: [String:String]
    
    init(_ json: JSON) {
        flavorTextTable = [:]
    }
}
