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
    
    lazy var pokemonListView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 250
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PokemonCell.self, forCellReuseIdentifier: PokemonCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setAsWhite()
        //let searchImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        //let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchTapped))
//        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: nil, action: nil)
//        searchButton.rx.tap.subscribe { [weak self] _ in
//            self?.searchTapped()
//        }.disposed(by: disposeBag)
//        navigationItem.rightBarButtonItem = searchButton
//
//        let logoImage = UIImage(named: "Logo")
//        let logoImageView = UIImageView(image: logoImage)
//        logoImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 0.30, height: 30)
//        logoImageView.contentMode = .scaleAspectFit
//        let logoContainer = UIView(frame: logoImageView.bounds)
//        logoContainer.addSubview(logoImageView)
//        let logoItem = UIBarButtonItem(customView: logoContainer)
//        navigationItem.leftBarButtonItem = logoItem
        
        // get init data
        viewModel.fetchPokemonList()
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

        viewModel.pokemonEntryList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] _ in
                self?.pokemonListView.reloadData()
        }).disposed(by: disposeBag)

        viewModel.title.bind(to: self.rx.title).disposed(by: disposeBag)

        pokemonListView.reachedBottom
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchPokemonList()
            }).disposed(by: disposeBag)
//
//        viewModel.presentAlert.subscribe(onNext: {[weak self] args in
//            let (title, msg) = args
//            self?.presentAlert(title: title, message: msg, callback: nil)
//        }).disposed(by: disposeBag)
    }
}

extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonEntryList.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.identifier)
            as? PokemonCell ?? PokemonCell()
        
        let entryData = viewModel.pokemonEntryList.value[indexPath.row]
        if let id = viewModel.parseUrlToPokemonId(urlString: entryData.url) {
            cell.queryPokemonData(id: id)
        }
        
        return cell
    }
}

extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PokemonDetailViewController(name: ""), animated: true)
    }
}

