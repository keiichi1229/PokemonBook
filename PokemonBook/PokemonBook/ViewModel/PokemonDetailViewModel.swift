//
//  PokemonDetailViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import RxRelay
import RxSwift
import SwiftyJSON

class PokemonDetailViewModel: BaseViewModel {
    let title = BehaviorRelay<NSAttributedString?>(value: nil)
    let name = BehaviorRelay<String>(value: "")
    
    init(name: String) {
        super.init()
        self.name.accept(name)
    }
    
    func fetchPokemonDetalData(name: String) {
        //todo:: cache
        
        
    }
}
