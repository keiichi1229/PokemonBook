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
    
    let showTypeSegmented: UISegmentedControl = {
        let listImg = UIImage(systemName: "list.bullet")
        let gridImg = UIImage(systemName: "square.grid.3x2")
        let segment = UISegmentedControl(items: [listImg, gridImg])
        segment.selectedSegmentIndex = 0
        
        return segment
        
    }()
    
    lazy var pokemonListView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self.viewModel.pokemonDataProvider
        tableView.delegate = self.viewModel.pokemonDataProvider
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        return tableView
    }()
    
    private lazy var pokemonGridView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self.viewModel.pokemonDataProvider
        collectionView.delegate = self.viewModel.pokemonDataProvider
        collectionView.register(PokemonGridCell.self, forCellWithReuseIdentifier: PokemonGridCell.identifier)
        // default is hidden
        collectionView.isHidden = true
        return collectionView
    }()
    
    let favoriteSwitch = FavoriteSwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setAsWhite()
        self.viewModel.pokemonDataProvider.coordinator = coordinator
        self.viewModel.favoriteDataProvider.coordinator = coordinator
        
        // set title
        let navLabel = UILabel()
        navLabel.adjustsFontSizeToFitWidth = true
        navLabel.attributedText = self.viewModel.title.value
        self.navigationItem.titleView = navLabel
        
        // set favorite switch
        let containerSwitchView = UIView()
        containerSwitchView.addSubview(favoriteSwitch)
        favoriteSwitch.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let barLeftButtonItem = UIBarButtonItem(customView: containerSwitchView)
        self.navigationItem.leftBarButtonItem = barLeftButtonItem
        
        // set show type segment
        let containerSegmentView = UIView()
        containerSegmentView.addSubview(showTypeSegmented)
        showTypeSegmented.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let barRightButtonItem = UIBarButtonItem(customView: containerSegmentView)
        self.navigationItem.rightBarButtonItem = barRightButtonItem
        
        // get init data
        viewModel.fetchPokemonList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pokemonListView.reloadData()
        pokemonGridView.reloadData()
        
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
        
        view.addSubview(pokemonGridView)
        pokemonGridView.snp.makeConstraints { make in
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
                self.pokemonGridView.reloadData()
            }).disposed(by: disposeBag)
        
        viewModel.isFavorite.skip(1)
            .subscribe(onNext: { [weak self] isFavorite in
                guard let self = self else { return }
                self.pokemonListView.delegate = isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                self.pokemonListView.dataSource = isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                
                self.pokemonGridView.delegate = isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                
                self.pokemonGridView.dataSource =  isFavorite ? self.viewModel.favoriteDataProvider : self.viewModel.pokemonDataProvider
                
                if self.pokemonListView.visibleCells.count > 0 {
                    self.pokemonListView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
                if isFavorite {
                    self.viewModel.fetchFavoritePokemonList()
                } else {
                    self.pokemonListView.reloadData()
                    self.pokemonGridView.reloadData()
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
        
        showTypeSegmented.rx.selectedSegmentIndex
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.pokemonListView.isHidden = index == 0 ? false : true
                self.pokemonGridView.isHidden = !self.pokemonListView.isHidden
                
                self.pokemonListView.reloadData()
                self.pokemonGridView.reloadData()
            }).disposed(by: disposeBag)
    }
}

