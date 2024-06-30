//
//  PokemonDetailViewModel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import RxRelay
import RxSwift
import SwiftyJSON
import Foundation

class PokemonDetailViewModel: BaseViewModel {
    let pId: String
    
    let title = BehaviorRelay<NSAttributedString>(value: NSAttributedString(string: ""))
    let flavorText = BehaviorRelay<String>(value: "")
    let types = BehaviorRelay<String>(value: "")
    let pokemonImgUrl = BehaviorRelay<String>(value: "")
    let evolutionIds = BehaviorRelay<[String]>(value: [])
    lazy var favorite = BehaviorRelay<Bool>(value: AppCache.shared.isFavorite(id: self.pId))
    var apiProvider: ApiProvider = ApiProvider.shared
    
    private let pokemonData = BehaviorRelay<PokemonData?>(value: nil)
    
    init(pId: String) {
        self.pId = pId
        super.init()
        bind()
    }
    
    private func bind() {
        self.pokemonData.subscribe(onNext: { [weak self] data in
            guard let data = data, let self = self else { return }
            self.updatePokemonProperty(data: data)
        }).disposed(by: disposeBag)
    }
    
    private func updatePokemonProperty(data: PokemonData) {
        let str1 = NSMutableAttributedString(string: data.name.capitalized,
                                             attributes: [.foregroundColor: UIColor.black,
                                                          .font: UIFont.dinProBold(30)])
        let str2 = NSAttributedString(string: "  \(data.id.formatToTag())",
                                      attributes: [.foregroundColor: UIColor.lightGray,
                                                   .font: UIFont.dinProBold(24)])
        str1.append(str2)
        
        self.title.accept(str1)
        
        var flavtorText = ""
        if data.flavorTextTable.count > 0 {
            if let currentLanguageCode = Locale.preferredLanguages.first {
                let locale = Locale(identifier: currentLanguageCode)
                if let languageCode = locale.languageCode, let scriptCode = locale.scriptCode {
                    flavtorText = data.flavorTextTable["\(languageCode)-\(scriptCode)"] ?? data.flavorTextTable["en"] ?? ""
                } else if let languageCode = locale.languageCode {
                    flavtorText = data.flavorTextTable[languageCode] ?? data.flavorTextTable["en"] ?? ""
                } else {
                    flavtorText = data.flavorTextTable["en"] ?? ""
                }
            } else {
                flavtorText = data.flavorTextTable["en"] ?? ""
            }
            
            self.flavorText.accept(flavtorText)
        }
        
        self.types.accept(data.types.capitalized)
        self.pokemonImgUrl.accept(data.imgUrl)
        self.evolutionIds.accept(data.evoChain)
    }
    
    func fetchPokemonDetailData() {
        if let pokemon = AppCache.shared.getPokemon(id: pId) {
            self.pokemonData.accept(pokemon)
        }
        
        self.manageActivityIndicator.accept(true)
        Observable.zip(apiProvider.observe(PokemonDataService.fetchPokemonDataFromId(pId: pId)),
                       apiProvider.observe(PokemonDataService.fetchPokemonSpeciesFromId(pId: pId)))
            .subscribe(onNext: { [weak self] event1, event2 in
                self?.manageActivityIndicator.accept(false)
                switch (event1, event2) {
                case let (.next(res1), .next(res2)):
                    var pokemonData = GetPokemonDataResponse(JSON(res1)).data
                    let speciesData = GetPokemonSpeciesResponse(JSON(res2))
                    pokemonData.updateFlavorTextTable(speciesData.flavorTextTable)
                    if !speciesData.evolutionId.isEmpty {
                        self?.fetchEvolutionChain(evoId: speciesData.evolutionId)
                    }
                    self?.pokemonData.accept(pokemonData)
                    AppCache.shared.savePokemon(id: pokemonData.id, pokemon: pokemonData)
                    AppCache.shared.updatePokemonFlavorTextTable(id: pokemonData.id, textTable: speciesData.flavorTextTable)
                case (.error(let err), _),
                     (_, .error(let err)):
                    self?.presentAlert.accept(("", err.msg))
                    #if DEBUG
                    print(err.msg)
                    #endif
                default:
                    return
                }
            
        }).disposed(by: disposeBag)
    }
    
    private func fetchEvolutionChain(evoId: String) {
        self.manageActivityIndicator.accept(true)
        apiProvider
            .request(PokemonDataService.fetchEvolutionChainFromId(evoId: evoId))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let evoIds = GetPokemonEvolutionChainResponse(JSON(res)).evolutionChainIds
                
                if var pokemon = self?.pokemonData.value {
                    pokemon.updateEvolutionChainIds(evoIds)
                    self?.pokemonData.accept(pokemon)
                    AppCache.shared.updatePokemonEvolutionChainIds(id: pokemon.id, ids: evoIds)
                }
            }, onFailure: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                self?.presentAlert.accept(("", err.msg))
                #if DEBUG
                print(err.msg)
                #endif
            }).disposed(by: disposeBag)
    }
    
    func updateFavorite() {
        self.favorite.accept(!self.favorite.value)
        AppCache.shared.updateFavorite(id: self.pId, favorite: self.favorite.value)
    }
}
