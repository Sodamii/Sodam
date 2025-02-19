//
//  DTOMapper.swift
//  Sodam
//
//  Created by EMILY on 11/02/2025.
//

import Foundation
import CoreData

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

struct HappinessMapper { // DTO <> Enitity 양방향으로 변환 시켜주니 Converter라는 이름도 잘 맞을 듯
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

    func toEntity(from dto: HappinessDTO, context: NSManagedObjectContext) -> Result<HappinessEntity, DataError> {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: dto.imagePaths, requiringSecureCoding: true)
        else {
            print(DataError.convertImagePathsFailed.localizedDescription)
            return .failure(DataError.convertImagePathsFailed)
        }

        let entity = HappinessEntity(context: context)
        entity.content = dto.content
        entity.date = dto.date
        entity.imagePaths = data

        return .success(entity)
    }
}
