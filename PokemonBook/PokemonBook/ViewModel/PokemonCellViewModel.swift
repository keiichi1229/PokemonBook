//
//  PokemonCellViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import RxRelay
import RxSwift
import SwiftyJSON

class PokemonCellViewModel: BaseViewModel {
    let id = BehaviorRelay<String>(value: "")
    let name = BehaviorRelay<String>(value: "")
    let pokemonImgUrl = BehaviorRelay<String>(value: "")
    let type = BehaviorRelay<String>(value: "")
    
    func fetchPokemonCellData(_ id: String) {
        ApiProvider.shared
            .request(PokemonDataService.fetchPokemonDataFromId(pId: id))
            .subscribe(onSuccess: { [weak self] res in
                let data = GetPokemonCellDataResponse(JSON(res)).data
                self?.id.accept(data.id.formatToTag())
                self?.name.accept(data.name.capitalized)
                self?.type.accept(data.type.capitalized)
                self?.pokemonImgUrl.accept(data.imgUrl)
        }, onFailure: { err in
            print("Cell Error:\(err)")
        }).disposed(by: disposeBag)
    }
}
