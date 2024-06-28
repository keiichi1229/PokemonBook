//
//  PokemonFavoriteDataProvider.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/28.
//

import UIKit
import RxRelay
import RxSwift

class PokemonFavoriteDataProvider: NSObject {
    private let disposeBag = DisposeBag()
    weak var coordinator: PokemonBookRouteDelegate?
    let favoriteIdList = BehaviorRelay<[String]>(value: [])
}

extension PokemonFavoriteDataProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteIdList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier)
            as? PokemonCell ?? PokemonCell()
        if indexPath.row < favoriteIdList.value.count {
            let id = favoriteIdList.value[indexPath.row]
            if !id.isEmpty {
                cell.queryPokemonData(id: id)
            }
        }
        return cell
    }
}

extension PokemonFavoriteDataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < favoriteIdList.value.count {
            let pokemonId = favoriteIdList.value[indexPath.row]
            self.coordinator?.gotoPokemonDetail(pId: pokemonId)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.contentOffset.y = 0
        }
    }
}
