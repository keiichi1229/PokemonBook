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
    
    init(pId: String) {
        super.init()
        //todo:: cache
        //noCache
        fetchPokemonData(pId: pId)
    }
    
    private func fetchPokemonData(pId: String) {
        ApiProvider.shared
            .request(PokemonDataService.fetchPokemonDataFromId(pId: pId))
            .subscribe(onSuccess: { [weak self] res in
                let data = GetPokemonDataResponse(JSON(res)).data
                self?.pokemonData.accept(data)
            }, onFailure: { err in
                #if DEBUG
                print(err.msg)
                #endif
            }).disposed(by: disposeBag)
    }
}
