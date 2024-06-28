//
//  GetPokemonEvolutionChainResponse.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import SwiftyJSON

struct GetPokemonEvolutionChainResponse: BaseResponse {
    var evolutionChainIds: [String] = []
    
    init(_ json: JSON) {
        evolutionChainIds = parseEvolutionChain(chain: json["chain"])
    }
    
    func parseEvolutionChain(chain: JSON) -> [String] {
        var evolutionURLs: [String] = []
        if let speciesURL = chain["species"]["url"].string {
            evolutionURLs.append(speciesURL)
        }
        let evolvesTo = chain["evolves_to"].arrayValue
        for evolution in evolvesTo {
            let childURLs = parseEvolutionChain(chain: evolution)
            evolutionURLs.append(contentsOf: childURLs)
        }
        return evolutionURLs.map { PokemonHelper.shared.parseUrlToPokemonId(urlString: $0) }
    }
}
