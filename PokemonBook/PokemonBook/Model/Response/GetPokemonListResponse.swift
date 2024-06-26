//
//  GetPokemonListResponse.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import SwiftyJSON

struct GetPokemonListResponse: BaseResponse {
    var data: [PokemonEntry]
    var maxCount: Int
    
    init(_ json: JSON) {
        data = json["results"].arrayValue.map { PokemonEntry($0) }
        maxCount = json["count"].intValue
    }
}
