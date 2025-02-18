//
//  +UIFont.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import UIKit

extension UIFont {
    static let mapoGoldenPier: (CGFloat) -> UIFont = {
        size in UIFont(name: CustomFont.mapoGoldenPier.rawValue, size: size) ?? UIFont()
    }

    static let sejongGeulggot: (CGFloat) -> UIFont = {
        size in UIFont(name: CustomFont.sejongGeulggot.rawValue, size: size) ?? UIFont()
    }

    static func gyeonggiBatang(type: FontType, size: CGFloat) -> UIFont {
        let fontName = "\(CustomFont.gyeonggiBatang)\(type.rawValue)" // rOTF, bOTF 중 사용가능
        print(fontName)
        return UIFont(name: fontName, size: size) ?? UIFont()
    }

    static func maruburiot(type: FontType, size: CGFloat) -> UIFont {
        let fontName = "\(CustomFont.maruBuriot.rawValue)-\(type.rawValue)" // bold, semiBold, regular 중 사용가능
        return UIFont(name: fontName, size: size) ?? UIFont()
    }

    static func gowunBatang(type: FontType, size: CGFloat) -> UIFont {
        let fontName = "\(CustomFont.gowunBatang.rawValue)-\(type.rawValue)" // bold, regular 중 사용가능
        return UIFont(name: fontName, size: size) ?? UIFont()
    }

    static func nanumNeo(type: FontType, size: CGFloat) -> UIFont {
        let fontName = "\(CustomFont.nanumSquareNeo.rawValue)-\(type.rawValue)" // neoBold, neoLight, neoRegular 중 사용가능
        return UIFont(name: fontName, size: size) ?? UIFont()
    }

    static func jGaegu(type: FontType, size: CGFloat) -> UIFont {
        let fontName = "\(CustomFont.jGaegujaengyi.rawValue)-\(type.rawValue)" // bold, jGaeguM, jGaeguL 중 사용가능
        return UIFont(name: fontName, size: size) ?? UIFont()
    }
}
