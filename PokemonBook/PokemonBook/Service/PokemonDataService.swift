//
//  PokemonDataService.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import Foundation
import Moya

enum PokemonDataService {
    case fetchPokemonList(limit: Int, offset: Int)
    case fetchPokemonDataFromId(pId: String)
    case fetchPokemonDataFromName(name: String)
    case fetchPokemonSpeciesFromName(name: String)
}

extension PokemonDataService: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
            return URL(string: "https://pokeapi.co/api/v2")!
    }
    
    var path: String {
        switch self {
        case .fetchPokemonList:
            return "/pokemon"
        case .fetchPokemonDataFromId(let pId):
            return "/pokemon/\(pId)"
        case .fetchPokemonDataFromName(let name):
            return "/pokemon/\(name)"
        case .fetchPokemonSpeciesFromName(let name):
            return "/pokemon-species/\(name)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPokemonList,
             .fetchPokemonDataFromId,
             .fetchPokemonDataFromName,
             .fetchPokemonSpeciesFromName:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .fetchPokemonList(limit, offset):
            var params : [String: Any] = [:]
            params = ["limit": limit,
                      "offset": offset]

            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .fetchPokemonDataFromId,
             .fetchPokemonDataFromName,
             .fetchPokemonSpeciesFromName:
            return .requestParameters(parameters: [:], encoding: URLEncoding.default)
            
            
        }
    }
}
