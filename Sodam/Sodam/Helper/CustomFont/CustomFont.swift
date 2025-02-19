//
//  CustomFont.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import UIKit

enum CustomFont {
    case mapoGoldenPier                                 // 마포금빛나루
    case sejongGeulggot                                 // 세종글꽃체
    case maruBuriot(weight: MaruBuriotWeight)            // 마루 부리
    case gyeonggiBatang(weight: GyeonggiBatangWeight)     // 경기천년바탕
    case gowunBatang(weight: GowunBatangWeight)           // 고운바탕
    case nanumSquareRound(weight: NanumSquareRoundWeight)  // 나눔스퀘어라운드
    
    var name: String {
        switch self {
        case .mapoGoldenPier: "MapoGoldenPier"
        case .sejongGeulggot: "SejongGeulggot"
        case .maruBuriot(let weight): "MaruBuriot\(weight.rawValue)"
        case .gyeonggiBatang(let weight): "GyeonggiBatang\(weight.rawValue)"
        case .gowunBatang(let weight): "GowunBatang\(weight.rawValue)"
        case .nanumSquareRound(let weight): "NanumSquareRound\(weight.rawValue)"
        }
    }
}

/// 폰트 별로 각 굵기에 해당하는 폰트 이름이 각자 다르기 때문에 따로 정의해주어 name 계산 프로퍼티에서 조합한다.
extension CustomFont {
    enum MaruBuriotWeight: String {
        case regular = "-Regular"
        case semiBold = "-SemiBold"
        case bold = "-Bold"
    }

    enum GyeonggiBatangWeight: String {
        case regular = "ROTF"
        case bold = "BOTF"
    }

    enum GowunBatangWeight: String {
        case regular = "-Regular"
        case bold = "-Bold"
    }

    enum NanumSquareRoundWeight: String {
        case light = "L"
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
}
