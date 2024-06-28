//
//  UIColor.swift
//  PokemonBook
//
//  Created by Raymondting on 2024/6/26.
//

import UIKit

extension UIColor {
    open class func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(displayP3Red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
    
    open class var lightGray242: UIColor {
        return .rgb(r: 242, g: 242, b: 242)
    }
    
    open class var graylite01: UIColor {
        return .rgb(r: 220, g: 228, b: 236)
    }
    
    open class var graylite02: UIColor {
        return .rgb(r: 241, g: 245, b: 249)
    }
}

enum PokemonTypeColor: String {
    case normal, fighting,
         flying, poison,
         ground, rock,
         bug, ghost,
         steel, fire,
         water, grass,
         electric, psychic,
         ice, dragon,
         dark, fairy,
         stellar, unknown
    
    func color() -> UIColor {
        switch self {
        case .normal:   return UIColor.rgb(r: 168, g: 168, b: 120)
        case .fighting: return UIColor.rgb(r: 192, g: 48, b: 40)
        case .flying:   return UIColor.rgb(r: 168, g: 144, b: 240)
        case .poison:   return UIColor.rgb(r: 160, g: 64, b: 160)
        case .ground:   return UIColor.rgb(r: 224, g: 192, b: 104)
        case .rock:     return UIColor.rgb(r: 184, g: 160, b: 56)
        case .bug:      return UIColor.rgb(r: 168, g: 184, b: 32)
        case .ghost:    return UIColor.rgb(r: 112, g: 88, b: 152)
        case .steel:    return UIColor.rgb(r: 184, g: 184, b: 208)
        case .fire:     return UIColor.rgb(r: 240, g: 128, b: 48)
        case .water:    return UIColor.rgb(r: 104, g: 144, b: 240)
        case .grass:    return UIColor.rgb(r: 120, g: 200, b: 80)
        case .electric: return UIColor.rgb(r: 248, g: 208, b: 48)
        case .psychic:  return UIColor.rgb(r: 248, g: 88, b: 136)
        case .ice:      return UIColor.rgb(r: 152, g: 216, b: 216)
        case .dragon:   return UIColor.rgb(r: 112, g: 56, b: 248)
        case .dark:     return UIColor.rgb(r: 112, g: 88, b: 72)
        case .fairy:    return UIColor.rgb(r: 238, g: 153, b: 172)
        case .stellar:  return UIColor.rgb(r: 76, g: 0, b: 153)
        case .unknown:  return UIColor.rgb(r: 104, g: 160, b: 144)
        }
    }
}
