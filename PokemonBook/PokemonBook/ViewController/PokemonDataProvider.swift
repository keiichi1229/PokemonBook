//
//  PokemonDataProvider.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/28.
//

import UIKit
import RxRelay
import RxSwift

class PokemonDataProvider: NSObject {
    private let disposeBag = DisposeBag()
    weak var coordinator: PokemonBookRouteDelegate?
    let pokemonIdList = BehaviorRelay<[String]>(value: [])
    let reachedBottom = PublishRelay<Void>()
}

extension PokemonDataProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonIdList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier)
            as? PokemonCell ?? PokemonCell()
        if indexPath.row < pokemonIdList.value.count {
            let id = pokemonIdList.value[indexPath.row]
            if !id.isEmpty {
                cell.queryPokemonData(id: id)
            }
        }
        return cell
    }
}

extension PokemonDataProvider: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < pokemonIdList.value.count {
            let pokemonId = pokemonIdList.value[indexPath.row]
            self.coordinator?.gotoPokemonDetail(pId: pokemonId)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            reachedBottom.accept(())
        }
    }
}
