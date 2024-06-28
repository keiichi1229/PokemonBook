//
//  EvolutionPokemonPanel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import UIKit
import RxSwift

protocol EvolutionPokemonPanelProtocol : AnyObject {
    func selectPokemon(pId: String)
}

class EvolutionPokemonPanel: UIView {
    
    private let disposeBag = DisposeBag()
    
    weak var delegate: EvolutionPokemonPanelProtocol?
    
    let backgroundImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "EvoBG"))
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    
    let titleLabel: PaddedLabel = {
        let label = PaddedLabel(insets: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        label.text = "Evolution"
        label.font = .dinProBold(25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(backgroundImgView)
        backgroundImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    
    func setupEvolutions(_ pIds: [String]) {
        stackView.removeAll()
        for pId in pIds {
            let view = EvolutionPokemonView(pId: pId)
            view.rx.tap.subscribe(onNext: {[weak self, pId] _ in
                self?.delegate?.selectPokemon(pId: pId)
            }).disposed(by: disposeBag)
            stackView.addArrangedSubview(view)
        }
    }
    
}
