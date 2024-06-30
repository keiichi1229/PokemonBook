//
//  PokemonCell.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import UIKit
import RxSwift
import RxCocoa

class PokemonCell: UITableViewCell {
    
    static let identifier = "PokemonCell"
    
    let disposeBag = DisposeBag()
    let viewModel = PokemonCellViewModel()
    
    private let baseView: UIView = {
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
        imageView.isHidden = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .dinPro(20)
        label.textColor = .lightGray
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .dinProBold(36)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .dinProMedium(16)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupViews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func queryPokemonData(id: String) {
        viewModel.fetchPokemonCellData(id)
    }
    
    private func setupViews() {
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        baseView.addSubview(thumbnailImgView)
        thumbnailImgView.snp.makeConstraints { make in
            make.leading.centerY.bottom.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        baseView.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(thumbnailImgView.snp.trailing).offset(8)
        }
        
        baseView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(idLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-50)
        }

        baseView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
        
        baseView.addSubview(favoriteImageView)
        favoriteImageView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
    
    private func bind() {
        viewModel.pokemonImgUrl
            .subscribe(onNext: { [weak self] url in
                self?.thumbnailImgView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "ImgPlaceHolder"))
            }).disposed(by: disposeBag)
        
        viewModel.name.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.displayId.bind(to: idLabel.rx.text).disposed(by: disposeBag)
        viewModel.types
            .map {PokemonHelper.shared.colorizedPokemonTypes($0)}
            .bind(to: self.typeLabel.rx.attributedText).disposed(by: disposeBag)
        viewModel.favorite.subscribe(onNext: { [weak self] isFavorite in
            self?.favoriteImageView.isHidden = false
            self?.favoriteImageView.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }).disposed(by: disposeBag)
        
        favoriteImageView.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.viewModel.updateFavorite()
        }).disposed(by: disposeBag)
    }
}

