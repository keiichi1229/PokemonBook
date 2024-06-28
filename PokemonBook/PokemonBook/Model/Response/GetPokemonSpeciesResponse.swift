//
//  GetPokemonSpeciesResponse.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import SwiftyJSON

struct GetPokemonSpeciesResponse: BaseResponse {
    var flavorTextTable: [String:String] = [:]
    var evolutionId: String
    
    init(_ json: JSON) {
        let flavorTextEntries = json["flavor_text_entries"].arrayValue
        for entry in flavorTextEntries {
            let language = entry["language"]["name"].stringValue
            let flavorText = entry["flavor_text"].stringValue
            flavorTextTable[language] = flavorText
        }
        
        if let evolutionChain = json["evolution_chain"].dictionary,
           let url = evolutionChain["url"]?.string {
            evolutionId = PokemonHelper.shared.parseUrlToPokemonId(urlString: url)
        } else {
            evolutionId = ""
        }
    }
}
