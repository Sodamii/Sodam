//
//  HangdamDTO.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import Foundation

struct HangdamDTO {
    let id: String              // 행담이는 DTO가 먼저 생성될 일이 없고, Entity에서 변환될 일만 있기 때문에 상수
    var name: String?
    var happinessCount: Int
    var startDate: String?
    var endDate: String?
    
    var level: Int {
        switch happinessCount {
        case 1...9: return 1
        case 10...24: return 2
        case 25...29: return 3
        case 30: return 4       // level 4 : 성장완료 보관 ㄱ
        default: return 0
        }
    }
}

extension HangdamEntity {
    var toDTO: HangdamDTO {
        return HangdamDTO(
            id: self.objectID.uriRepresentation().absoluteString,
            name: self.name,
            happinessCount: self.happinesses?.count ?? 0,
            startDate: self.startDate?.toFormattedString,
            endDate: self.endDate?.toFormattedString
        )
    }
}
