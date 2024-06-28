//
//  UIView.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/27.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIView {
    var tap: ControlEvent<Void> {
        let tapGesture = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGesture)
        
        return ControlEvent(events: tapGesture.rx.event.map { _ in () })
    }
}
