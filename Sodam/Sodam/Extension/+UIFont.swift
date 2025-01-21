//
//  +UIFont.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import UIKit

extension UIFont {
    static let mapoGoldenPier: (CGFloat) -> UIFont = { size in UIFont(name: CustomFont.MapoGoldenPier.rawValue, size: size) ?? UIFont()
    }
    
    static let sejongGeulggot: (CGFloat) -> UIFont = { size in UIFont(name: CustomFont.SejongGeulggot.rawValue, size: size) ?? UIFont()
    }
}
