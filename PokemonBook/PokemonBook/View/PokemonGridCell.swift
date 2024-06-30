//
//  PokemonGridCell.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/29.
//

import UIKit
import RxSwift

class PokemonGridCell: UICollectionViewCell {
    static let identifier = "PokemonGridCell"
    
    let disposeBag = DisposeBag()
    let viewModel = PokemonCellViewModel()
    
    let baseView: UIView = {
        let base = UIView()
        base.backgroundColor = .white
        base.layer.shadowColor = UIColor.black.cgColor
        base.layer.cornerRadius = 16
        base.layer.shadowOpacity = 0.1
        base.layer.shadowRadius = 4
        base.layer.shadowOffset = CGSize(width: 0, height: 1)
        return base
    }()
    
    let thumbnailImgView: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFit
        return thumbnail
    }()
    
    let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        imageView.tintColor = .red
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .dinProBold(20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private func setupViews() {
        contentView.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        baseView.addSubview(thumbnailImgView)
        thumbnailImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        baseView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImgView.snp.bottom)
            make.height.equalTo(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        baseView.addSubview(favoriteImageView)
        favoriteImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(5)
        }
    }
    
    private func bind() {
        viewModel.pokemonImgUrl
            .subscribe(onNext: { [weak self] url in
                self?.thumbnailImgView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "ImgPlaceHolder"))
            }).disposed(by: disposeBag)
        
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.favorite.subscribe(onNext: { [weak self] isFavorite in
            self?.favoriteImageView.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }).disposed(by: disposeBag)
        
        favoriteImageView.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.updateFavorite()
        }).disposed(by: disposeBag)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bind()
    }
    
    func queryPokemonData(id: String) {
        viewModel.fetchPokemonCellData(id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
