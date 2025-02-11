//
//  DTOMapper.swift
//  Sodam
//
//  Created by EMILY on 11/02/2025.
//

import Foundation

struct HangdamMapper {
    func toDTO(from entity: HangdamEntity) -> HangdamDTO {
        return HangdamDTO(
            id: IDConverter.toStringID(from: entity.objectID),
            name: entity.name,
            happinessCount: entity.happinesses?.count ?? 0,
            startDate: entity.startDate?.formatForHangdam,
            endDate: entity.endDate?.formatForHangdam
        )
    }
}

struct HappinessMapper {
    func toDTO(from entity: HappinessEntity) -> HappinessDTO? {
        guard let content = entity.content,
              let date = entity.date,
              let imagePaths = entity.imagePaths?.toStringArray
        else { return nil }
        
        return HappinessDTO(
            id: IDConverter.toStringID(from: entity.objectID),
            content: content,
            date: date,
            imagePaths: imagePaths,
            hangdamID: IDConverter.toStringID(from: entity.hangdam?.objectID)
        )
    }
}
