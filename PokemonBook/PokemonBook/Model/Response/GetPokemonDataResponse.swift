//
//  GetPokemonDataResponse.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import SwiftyJSON

struct GetPokemonDataResponse: BaseResponse {
    var data: PokemonData
    
    init(_ json: JSON) {
        data = PokemonData(json)
    }
}
