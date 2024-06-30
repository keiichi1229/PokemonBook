//
//  PokemonListViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import RxRelay
import RxSwift
import SwiftyJSON
import Foundation

class PokemonListViewModel: BaseViewModel {
    let pokemonDataProvider = PokemonDataProvider()
    let favoriteDataProvider = PokemonFavoriteDataProvider()
    var apiProvider: ApiProvider = ApiProvider.shared
    
    let isFavorite = BehaviorRelay<Bool>(value: false)
    
    let onePagelimit = 50
    var pageOffset = 0
    private(set) var maxPokemon = 0
    
    override init() {
        super.init()
        bind()
    }
    
    func bind() {
        pokemonDataProvider.reachedBottom
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.fetchPokemonList()
            }).disposed(by: disposeBag)
    }
    
    func showFavorite(favorite: Bool) {
        isFavorite.accept(favorite)
    }
    
    func fetchPokemonList() {
        if maxPokemon != 0, maxPokemon <= pageOffset { return }
        
        if !AppCache.shared.getInitIds().isEmpty,
           pokemonDataProvider.pokemonIdList.value.isEmpty {
            pokemonDataProvider.pokemonIdList.accept(AppCache.shared.getInitIds())
        }
        
        manageActivityIndicator.accept(true)
        
        apiProvider
            .request(PokemonDataService.fetchPokemonList(limit: onePagelimit, offset: pageOffset))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let pokemonListResponse = GetPokemonListResponse(JSON(res))
                self?.maxPokemon = pokemonListResponse.maxCount
                let pokemonEntryList = pokemonListResponse.data
                var list = self?.pokemonDataProvider.pokemonIdList.value
                
                if let offset = self?.pageOffset, offset == 0 {
                    // clean cache
                    list?.removeAll()
                }
                
                for entry in pokemonEntryList {
                    list?.append(PokemonHelper.shared.parseUrlToPokemonId(urlString: entry.url))
                }
                
                if let list = list {
                    self?.pokemonDataProvider.pokemonIdList.accept(list)
                }
                
                self?.pageOffset += self?.onePagelimit ?? 0
                
                // clear http request cache for list
                URLCache.shared.removeAllCachedResponses()
            }, onFailure: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                self?.presentAlert.accept(("", err.msg))
            }).disposed(by: disposeBag)
    }
    
    func fetchFavoritePokemonList() {
        let favoriteList = AppCache.shared.getFavoritePokemonIds()
        favoriteDataProvider.favoriteIdList.accept(favoriteList)
    }
}
