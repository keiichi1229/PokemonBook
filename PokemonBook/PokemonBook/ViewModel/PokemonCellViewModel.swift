//
//  PokemonCellViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import RxRelay
import RxSwift
import SwiftyJSON
import SwiftUI

class PokemonCellViewModel: BaseViewModel {
    private(set) var pId: String = ""
    let displayId = BehaviorRelay<String>(value: "")
    let name = BehaviorRelay<String>(value: "")
    let pokemonImgUrl = BehaviorRelay<String>(value: "")
    let types = BehaviorRelay<String>(value: "")
    let favorite = BehaviorRelay<Bool>(value: false)
    var apiProvider: ApiProvider = ApiProvider.shared
    
    func fetchPokemonCellData(_ id: String) {
        if let pokemon = AppCache.shared.getPokemon(id: id) {
            setupPokemon(data: pokemon)
        }
    
        apiProvider
            .request(PokemonDataService.fetchPokemonDataFromId(pId: id))
            .subscribe(onSuccess: { [weak self] res in
                let data = GetPokemonDataResponse(JSON(res)).data
                AppCache.shared.savePokemon(id: data.id, pokemon: data)
                self?.setupPokemon(data: data)
        }, onFailure: { err in
            print("PokemonCell Error:\(err)")
        }).disposed(by: disposeBag)
    }
    
    private func setupPokemon(data: PokemonData) {
        self.displayId.accept(data.id.formatToTag())
        self.name.accept(data.name.capitalized)
        self.types.accept(data.types.capitalized)
        self.pokemonImgUrl.accept(data.imgUrl)
        self.favorite.accept(AppCache.shared.isFavorite(id: data.id))
        self.pId = data.id
    }
    
    func updateFavorite() {
        self.favorite.accept(!self.favorite.value)
        AppCache.shared.updateFavorite(id: self.pId, favorite: self.favorite.value)
    }
}
