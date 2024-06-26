//
//  BaseViewController.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/24.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie
import SnapKit

class BaseViewController: UIViewController {
    
    static let loadingViewIdentifier = "loadingView"
    
    internal let disposeBag = DisposeBag()
    
    private let animationView: AnimationView = {
        let view = AnimationView(filePath: Bundle.main.path(forResource: "Loading", ofType: "json") ?? "")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = false
        return view
    }()
    
    private lazy var bgView: UIView = {
        let frame = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.accessibilityIdentifier = BaseViewController.loadingViewIdentifier
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(80)
        }
        return view
    }()
    
    internal var manageActivityIndicator = PublishRelay<Bool>()
    
    internal func initSubviews() {}
    
    internal func bind() {
        manageActivityIndicator.subscribe(onNext: { [weak self] animate in
            guard let self = self else { return }
            if animate {
                self.bgView.removeFromSuperview()
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                        window.addSubview(self.bgView)
                    }
                }
                self.animationView.play()
                self.view.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
            } else {
                self.bgView.removeFromSuperview()
                self.animationView.pause()
                self.view.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }
        }).disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        initSubviews()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        manageActivityIndicator.accept(false)
    }
}
