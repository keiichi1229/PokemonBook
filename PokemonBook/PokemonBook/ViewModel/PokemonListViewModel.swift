//
//  PokemonListViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import RxRelay
import RxSwift
import SwiftyJSON

class PokemonListViewModel: BaseViewModel {
    let onePagelimit = 20
    var pageOffset = 0
    private(set) var maxPokemon = 0
    
    let title = BehaviorRelay<String>(value: "Pokemon List")
    let pokemonEntryList = BehaviorRelay<[PokemonEntry]>(value: [])
    
    func fetchPokemonList() {
        if maxPokemon != 0, maxPokemon <= pageOffset { return }
        
        manageActivityIndicator.accept(true)
        
        ApiProvider.shared
            .request(PokemonDataService.fetchPokemonList(limit: onePagelimit, offset: pageOffset))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let pokemonListResponse = GetPokemonListResponse(JSON(res))
                self?.maxPokemon = pokemonListResponse.maxCount
                let pokemonList = pokemonListResponse.data
                var list = self?.pokemonEntryList.value
                
                for entry in pokemonList {
                    list?.append(entry)
                }
                
                if let list = list {
                    self?.pokemonEntryList.accept(list)
                }
                
                self?.pageOffset += self?.onePagelimit ?? 0
                
            }).disposed(by: disposeBag)
    }
    
    func parseUrlToPokemonId(urlString :String) -> String? {
        if let url = URL(string: urlString), let lastPathComponent = url.pathComponents.last {
            let idString = lastPathComponent.replacingOccurrences(of: "/", with: "")
            return idString
        } else {
            return nil
        }
    }
}
