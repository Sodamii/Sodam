//
//  CustomFont.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import UIKit

enum CustomFont {
    case mapoGoldenPier
    case sejongGeulggot
    case maruBuriot(weight: MaruBuriotWeight)
    case maplestory(weight: MaplestoryWeight)
    case gyeonggiBatang(weight: GyeonggiBatangWeight)
    case nanumSquareRound(weight: NanumSquareRoundWeight)
    case leeSeoyun
    case gowunDodum
    case gabiaGosran
    case gabiaHeuldot
    
    /// CustomFontManager.printFontNames()로 확인할 수 있는 폰트 고유 이름. UIFont(name: ) 파라미터에 이 값을 넣어줘야 한다.
    var sourceName: String {
        switch self {
        case .mapoGoldenPier: "MapoGoldenPier"
        case .sejongGeulggot: "SejongGeulggot"
        case .maruBuriot(let weight): "MaruBuriot\(weight.rawValue)"
        case .maplestory(let weight): "Maplestory\(weight.rawValue)"
        case .gyeonggiBatang(let weight): "GyeonggiBatang\(weight.rawValue)"
        case .nanumSquareRound(let weight): "NanumSquareRound\(weight.rawValue)"
        case .leeSeoyun: "LeeSeoyun"
        case .gowunDodum: "GowunDodum-Regular"
        case .gabiaGosran: "GabiaGosran-Regular"
        case .gabiaHeuldot: "GabiaHeuldot-Regular"
        }
    }
    
    /// 폰트 공식 홈페이지에 써있는 명칭 (띄어쓰기까지 지킴)
    var name: String {
        switch self {
        case .mapoGoldenPier: "마포금빛나루"
        case .sejongGeulggot: "세종글꽃체"
        case .maruBuriot: "마루 부리"
        case .maplestory: "넥슨 메이플스토리"
        case .gyeonggiBatang: "경기청년바탕"
        case .nanumSquareRound: "나눔스퀘어라운드"
        case .leeSeoyun: "이서윤체"
        case .gowunDodum: "고운돋움"
        case .gabiaGosran: "가비아 고스란체"
        case .gabiaHeuldot: "가비아 흘돋체"
        }
    }
    
    /// 폰트 이름 배열 : 설정 tableView DataSource로 활용
    static var allFontNames: [String] {
        let allCases: [CustomFont] = [
            .mapoGoldenPier,
            .sejongGeulggot,
            .maruBuriot(weight: .regular),
            .maplestory(weight: .light),
            .gyeonggiBatang(weight: .regular),
            .nanumSquareRound(weight: .regular),
            .leeSeoyun,
            .gowunDodum,
            .gabiaGosran,
            .gabiaHeuldot
        ]
        
        return allCases.map { $0.name }
    }
}

/// 폰트 별로 각 굵기에 해당하는 폰트 이름이 각자 다르기 때문에 따로 정의해주어 sourceName 계산 프로퍼티에서 조합한다.
extension CustomFont {
    enum MaruBuriotWeight: String {
        case regular = "-Regular"
        case semiBold = "-SemiBold"
        case bold = "-Bold"
    }
    
    enum MaplestoryWeight: String {
        case light = "Light"
        case bold = "Bold"
    }
    
    enum GyeonggiBatangWeight: String {
        case regular = "ROTF"
        case bold = "BOTF"
    }
    
    enum NanumSquareRoundWeight: String {
        case light = "L"
        case regular = "R"
        case bold = "B"
        case extraBold = "EB"
    }
}
