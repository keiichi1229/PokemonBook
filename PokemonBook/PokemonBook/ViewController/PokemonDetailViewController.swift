//
//  PokemonDetailViewController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import UIKit

class PokemonDetailViewController: BaseViewController {
    
    var viewModel: PokemonDetailViewModel
    
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
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "imgPlaceHolder")
        imgView.backgroundColor = .red
        return imgView
    }()
    
    let flavorTextLabel: UILabel = {
        let label = UILabel()
        label.font = .dinProMedium(16)
        label.numberOfLines = 0
        label.text = "ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABC"
        label.backgroundColor = .green
        return label
    }()
    
    let typesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "ABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABCABC"
        label.backgroundColor = .yellow
        return label
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
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width * 0.5)
        }
        
        contentView.addSubview(flavorTextLabel)
        flavorTextLabel.snp.makeConstraints { make in
            make.top.equalTo(pokemonImgView)
            make.leading.equalTo(pokemonImgView.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
        }
        
        contentView.addSubview(typesLabel)
        typesLabel.snp.makeConstraints { make in
            make.top.equalTo(flavorTextLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(flavorTextLabel)
        }
    }
    
    init(name: String) {
        viewModel = PokemonDetailViewModel(name: name)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray242
    }
}
