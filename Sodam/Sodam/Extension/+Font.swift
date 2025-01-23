//
//  +Font.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

extension Font {
    static let mapoGoldenPier: (CGFloat) -> Font = { size in
        return .custom(CustomFont.MapoGoldenPier.rawValue, size: size)
    }
    
    static let sejongGeulggot: (CGFloat) -> Font = { size in
        return .custom(CustomFont.SejongGeulggot.rawValue, size: size)
    }
    
    static func gyeonggiBatang(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.GyeonggiBatang)\(type.rawValue)" // rOTF, bOTF 중 사용가능
        print(fontName)
        return .custom(fontName, size: size)
    }
    
    static func maruburiot(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.MaruBuriot.rawValue)-\(type.rawValue)" // bold, semiBold, regular 중 사용가능
        return .custom(fontName, size: size)
    }
    
    static func gowunBatang(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.GowunBatang.rawValue)-\(type.rawValue)" // bold, regular 중 사용가능
        return .custom(fontName, size: size)
    }
    
    static func nanumNeo(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.NanumSquareNeo.rawValue)-\(type.rawValue)" // neoBold, neoLight, neoRegular 중 사용가능
        return .custom(fontName, size: size)
    }
    
    static func jGaegu(type: FontType, size: CGFloat) -> Font {
        let fontName = "\(CustomFont.JGaegujaengyi.rawValue)-\(type.rawValue)" // bold, jGaeguM, jGaeguL 중 사용가능
        return .custom(fontName, size: size)
    }
}
