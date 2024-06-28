//
//  PokemonListViewController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import UIKit
import RxSwift

class PokemonListViewController: BaseViewController {
    
    let viewModel = PokemonListViewModel()
    
    lazy var coordinator = PokemonBookCoordinator(navigationController)
    
    lazy var pokemonListView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self.viewModel.pokemonDataProvider //self
        tableView.delegate = self.viewModel.pokemonDataProvider
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        return tableView
    }()
    
    let favoriteSwitch = FavoriteSwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setAsWhite()
        self.viewModel.pokemonDataProvider.coordinator = coordinator
        self.viewModel.favoriteDataProvider.coordinator = coordinator
        
        // set title
        let navLabel = UILabel()
        navLabel.attributedText = self.viewModel.title.value
        self.navigationItem.titleView = navLabel
        
        
        let containerView = UIView()
        containerView.addSubview(favoriteSwitch)
        favoriteSwitch.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let barButtonItem = UIBarButtonItem(customView: containerView)
        self.navigationItem.leftBarButtonItem = barButtonItem
        
        // get init data
        viewModel.fetchPokemonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pokemonListView.reloadData()
        
        if viewModel.isFavorite.value {
            viewModel.fetchFavoritePokemonList()
        }
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let bottom = UIApplication.shared.bottomSafeAreaInset
        view.addSubview(pokemonListView)
        pokemonListView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(bottom)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.pokemonDataProvider.pokemonIdList,
                                 viewModel.favoriteDataProvider.favoriteIdList)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pokemonListView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.isFavorite.skip(1)
            .subscribe(onNext: { [weak self] isFavorite in
                guard let self = self else { return }
                self.pokemonListView.delegate = isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                self.pokemonListView.dataSource = isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                
                if self.pokemonListView.visibleCells.count > 0 {
                    self.pokemonListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
                if isFavorite {
                    self.viewModel.fetchFavoritePokemonList()
                } else {
                    self.pokemonListView.reloadData()
                }
            }).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
            let (title, msg) = args
            self?.presentAlert(title: title, message: msg, callback: nil)
        }).disposed(by: disposeBag)
        
        favoriteSwitch.isOn.skip(1)
            .subscribe(onNext: { [weak self] isFavorite in
            self?.viewModel.showFavorite(favorite: isFavorite)
        }).disposed(by: disposeBag)
    }
}

