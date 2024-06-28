//
//  FavoriteSwitch.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/28.
//

import UIKit
import RxSwift
import RxRelay

class FavoriteSwitch: UIView {
    
    let isOnChanged = PublishRelay<Bool>()
    let isOn = BehaviorRelay<Bool>(value: false)
    let isEnabled = BehaviorRelay<Bool>(value: true)
    
    private let disposeBag = DisposeBag()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let heartImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart.fill")
        view.tintColor = .red
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    private let circleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.circle(diameter: 12, color: .white)
        return view
    }()
    
    private func initSubviews() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.addArrangedSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(28)
            make.leading.top.bottom.equalToSuperview()
        }
        
        backgroundView.addSubview(circleImageView)
        circleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(2)
        }
        
        stackView.addArrangedSubview(heartImageView)
    }
    
    private func bind() {
        self.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else {
                return
            }
            guard self.isEnabled.value else {
                return
            }
            let currentVal = self.isOn.value
            self.isOn.accept(!currentVal)
            self.isOnChanged.accept(!currentVal)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(isEnabled, isOn)
            .subscribe(onNext: { [weak self] isEnabled, isOn in
                UIView.animate(withDuration: 0.2, animations: {
                    self?.circleImageView.snp.updateConstraints { make in
                        make.leading.equalToSuperview().offset(isOn && isEnabled ? 22 : 2)
                    }
                    
                    // Favorite bar is red
                    self?.backgroundView.backgroundColor = !isEnabled
                                                            ? .graylite02
                                                            : isOn ? .red : .gray
                    self?.backgroundView.layoutIfNeeded()
                })
            }).disposed(by: disposeBag)
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: (48 + 25), height: 28))
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
