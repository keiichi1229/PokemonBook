//
//  PokemonDetailViewController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import UIKit

class PokemonDetailViewController: BaseViewController {
    
    var viewModel: PokemonDetailViewModel
    
    weak var coordinator: PokemonBookRouteDelegate?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    let pokemonImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .graylite01
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "imgPlaceHolder")
        return imgView
    }()
    
    let flavorTextLabel: PaddedLabel = {
        let label = PaddedLabel(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        label.font = .dinPro(15)
        label.text = "Flavor Text"
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let flavorTextValueLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .dinProMedium(18)
        label.numberOfLines = 0
        return label
    }()
    
    let typesLabel: PaddedLabel = {
        let label = PaddedLabel(insets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        label.font = .dinPro(15)
        label.text = "Types"
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    let typesValueLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = .dinProBold(16)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var evoluationPanel: EvolutionPokemonPanel = {
        let panel = EvolutionPokemonPanel()
        panel.isHidden = true
        panel.delegate = self
        return panel
    }()
    
    lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: nil, action: nil)
        button.tintColor = .red
        button.rx.tap.subscribe { [weak self] _ in
            self?.viewModel.updateFavorite()
        }.disposed(by: disposeBag)
        return button
    }()
    
    override func initSubviews() {
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let bottom = UIApplication.shared.bottomSafeAreaInset
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalToSuperview().offset(-bottom - 10) // take some gap
        }
        
        contentView.addSubview(pokemonImgView)
        pokemonImgView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(250)
        }
        
        contentView.addSubview(flavorTextLabel)
        flavorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(pokemonImgView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        contentView.addSubview(flavorTextValueLabel)
        flavorTextValueLabel.snp.makeConstraints { make in
            make.top.equalTo(flavorTextLabel.snp.bottom).offset(8)
            make.leading.equalTo(flavorTextLabel)
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(typesLabel)
        typesLabel.snp.makeConstraints { make in
            make.top.equalTo(flavorTextValueLabel.snp.bottom).offset(20)
            make.leading.equalTo(flavorTextLabel)
        }
        
        contentView.addSubview(typesValueLabel)
        typesValueLabel.snp.makeConstraints { make in
            make.top.equalTo(typesLabel.snp.bottom).offset(8)
            make.leading.equalTo(typesLabel)
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(evoluationPanel)
        evoluationPanel.snp.makeConstraints { make in
            make.top.equalTo(typesValueLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    init(pId: String) {
        viewModel = PokemonDetailViewModel(pId: pId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray242
        navigationItem.rightBarButtonItem = favoriteButton
        
        
        viewModel.fetchPokemonDetailData()
    }
    
    override func bind() {
        viewModel.title.subscribe(onNext: { [weak self] title in
            let navLabel = UILabel()
            navLabel.attributedText = title
            self?.navigationItem.titleView = navLabel
        }).disposed(by: disposeBag)
        
        viewModel.pokemonImgUrl.subscribe(onNext: { [weak self] url in
            self?.pokemonImgView.kf
                .setImage(with: URL(string: url),
                          placeholder: UIImage(named: "ImgPlaceHolder"))
        }).disposed(by: disposeBag)
        
        viewModel.types
            .map {PokemonHelper.shared.colorizedPokemonTypes($0)}
            .bind(to: self.typesValueLabel.rx.attributedText).disposed(by: disposeBag)
        
        viewModel.flavorText.bind(to: self.flavorTextValueLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.evolutionIds
            .skip(1)
            .subscribe(onNext: { [weak self] ids in
                self?.evoluationPanel.isHidden = ids.count == 0
                self?.evoluationPanel.setupEvolutions(ids)
            }).disposed(by: disposeBag)
        
        viewModel.favorite.subscribe(onNext: { [weak self] isFavorite in
            self?.favoriteButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
            
        }).disposed(by: disposeBag)
    }
}

extension PokemonDetailViewController: EvolutionPokemonPanelProtocol {
    func selectPokemon(pId: String) {
        // skip the same id
        if pId != viewModel.pId {
            coordinator?.gotoPokemonDetail(pId: pId)
        }
    }
}
