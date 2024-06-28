//
//  EvolutionPokemonView.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import UIKit
import RxSwift

class EvolutionPokemonView: UIView {
    
    let viewModel: EvolutionPokemonViewModel
    
    let disposeBag = DisposeBag()
    
    let pokenmonImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.borderWidth = 3
        imgView.layer.borderColor = UIColor.white.cgColor
        imgView.layer.cornerRadius = 3
        imgView.layer.masksToBounds = true
        return imgView
        
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .dinProBold(20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()

    init(pId: String) {
        viewModel = EvolutionPokemonViewModel(pId: pId)
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.addArrangedSubview(pokenmonImgView)
        stackView.addArrangedSubview(nameLabel)
    }
    
    private func bind() {
        viewModel.pokemonData.subscribe(onNext: { [weak self] pokemonData in
            guard let data = pokemonData, let self = self else { return }
            self.pokenmonImgView.kf.setImage(with: URL(string: data.imgUrl), placeholder: UIImage(named: "ImgPlaceHolder"))
            self.nameLabel.text = data.name.capitalized
        }).disposed(by: disposeBag)
    }
    
}
