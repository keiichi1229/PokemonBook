//
//  PaddingLabel.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/25.
//

import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet {
            setNeedsDisplay()
        }
    }

    convenience init(insets: UIEdgeInsets) {
        self.init()
        self.textInsets = insets
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
