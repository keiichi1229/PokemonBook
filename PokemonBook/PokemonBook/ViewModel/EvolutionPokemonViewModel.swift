//
//  EvolutionPokemonViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import RxRelay
import RxSwift
import SwiftyJSON
import Foundation

class EvolutionPokemonViewModel: BaseViewModel {
    let pokemonData = BehaviorRelay<PokemonData?>(value: nil)
    var apiProvider: ApiProvider = ApiProvider.shared
    
    init(pId: String) {
        super.init()
        fetchPokemonData(pId: pId)
    }
    
    private func fetchPokemonData(pId: String) {
        // check cache
        if let pokemon = AppCache.shared.getPokemon(id: pId) {
            self.pokemonData.accept(pokemon)
        }
        
        apiProvider
            .request(PokemonDataService.fetchPokemonDataFromId(pId: pId))
            .subscribe(onSuccess: { [weak self] res in
                let data = GetPokemonDataResponse(JSON(res)).data
                self?.pokemonData.accept(data)
                // update cache
                AppCache.shared.savePokemon(id: data.id, pokemon: data)
            }, onFailure: { err in
                #if DEBUG
                print(err.msg)
                #endif
            }).disposed(by: disposeBag)
    }
}
