//
//  AppCache.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import Foundation

enum CacheType: String {
    case pokemonStorage
    case favorite
}

class AppCache {
    
    static let shared = AppCache()
    
    private let dataLock = NSLock()
    private let userDefaults = UserDefaults.standard
    private var pokemonCache: [String: PokemonData] = [:]
    private var favoriteCache: [String: Bool] = [:]
    
    init() {
        if let data = userDefaults.data(forKey: CacheType.pokemonStorage.rawValue),
           let decodedCache = try? JSONDecoder().decode([String: PokemonData].self, from: data) {
            pokemonCache = decodedCache
        }
        
        if let data = userDefaults.data(forKey: CacheType.favorite.rawValue),
           let decodedCache = try? JSONDecoder().decode([String: Bool].self, from: data) {
            favoriteCache = decodedCache
        }
    }

    func savePokemon(id: String, pokemon: PokemonData) {
        dataLock.lock()
        guard var pokemonData = pokemonCache[id] else {
            pokemonCache[id] = pokemon
            saveCache(.pokemonStorage)
            dataLock.unlock()
            return
        }
        
        pokemonData.updateDefaultInfo(pokemon: pokemon)
        pokemonCache[id] = pokemonData
        saveCache(.pokemonStorage)
        dataLock.unlock()
    }
    
    func updatePokemonFlavorTextTable(id: String, textTable: [String:String]) {
        guard var pokemon = pokemonCache[id] else {
            return
        }
        
        dataLock.lock()
        pokemon.updateFlavorTextTable(textTable)
        pokemonCache[id] = pokemon
        saveCache(.pokemonStorage)
        dataLock.unlock()
    }
    
    func updatePokemonEvolutionChainIds(id: String, ids: [String]) {
        guard var pokemon = pokemonCache[id] else {
            return
        }
        
        dataLock.lock()
        pokemon.updateEvolutionChainIds(ids)
        pokemonCache[id] = pokemon
        saveCache(.pokemonStorage)
        dataLock.unlock()
    }

    func getPokemon(id: String) -> PokemonData? {
        return pokemonCache[id]
    }
    
    func isFavorite(id: String) -> Bool {
        return favoriteCache[id] ?? false
    }
    
    func updateFavorite(id: String, favorite: Bool) {
        dataLock.lock()
        favoriteCache[id] = favorite
        saveCache(.favorite)
        dataLock.unlock()
    }
    
    func getFavoritePokemonIds() -> [String] {
        return favoriteCache.filter { $0.value == true }
        .compactMap {Int($0.key)}
        .sorted()
        .map { String($0) }
    }
    
    func getInitIds() -> [String] {
        return pokemonCache.compactMap {Int($0.key)}.sorted().map { String($0) }
    }

    private func saveCache(_ key: CacheType) {
        switch key {
        case .pokemonStorage:
            if let encodedCache = try? JSONEncoder().encode(pokemonCache) {
                userDefaults.set(encodedCache, forKey: CacheType.pokemonStorage.rawValue)
            }
        case .favorite:
            if let encodedCache = try? JSONEncoder().encode(favoriteCache) {
                userDefaults.set(encodedCache, forKey: CacheType.favorite.rawValue)
            }
        default:
            return
        }
        
        
    }
}
