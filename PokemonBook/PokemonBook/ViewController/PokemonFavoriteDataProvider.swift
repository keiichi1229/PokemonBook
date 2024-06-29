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
    private let itemsPerRow: CGFloat = 3
}

extension PokemonFavoriteDataProvider: UITableViewDataSource, UITableViewDelegate {
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

extension PokemonFavoriteDataProvider: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteIdList.value.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonGridCell.identifier, for: indexPath) as? PokemonGridCell ?? PokemonGridCell()
        if indexPath.row < favoriteIdList.value.count {
            let id = favoriteIdList.value[indexPath.row]
            if !id.isEmpty {
                cell.queryPokemonData(id: id)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < favoriteIdList.value.count {
            let pokemonId = favoriteIdList.value[indexPath.row]
            self.coordinator?.gotoPokemonDetail(pId: pokemonId)
        }
    }
}

extension PokemonFavoriteDataProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let sectionInsets: CGFloat = 5
        let totalPadding = padding * (itemsPerRow - 1) + sectionInsets * 2
        let width = (collectionView.frame.width - totalPadding) / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            let padding: CGFloat = 5
            return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
