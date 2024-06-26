//
//  BaseViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import RxSwift
import RxCocoa

class BaseViewModel {
    
    let disposeBag = DisposeBag()

    //title, message
    let presentAlert = PublishRelay<(String,String)>()

    let manageActivityIndicator = PublishRelay<Bool>()
    
    init() {}
}
