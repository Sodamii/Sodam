//
//  HangdamRepository + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

import CoreData

extension HangdamRepository {
    func fetchHangdamByIdAsync(id: String?) async throws -> HangdamDTO {
        let hangdam: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(id: id)
        return dtoMapper.toDTO(from: hangdam)
    }

    func fetchCurrentHangdmaAsync() async throws -> HangdamDTO {
        let hangdams: [HangdamEntity] = try await coreDataManager.fetchEntitiesAsync(entityType: hangdamType)

        if let currentHangdam: HangdamEntity = hangdams.last,
           currentHangdam.endDate == nil {
            return dtoMapper.toDTO(from: currentHangdam)
        } else {
            let newHangdam: HangdamEntity = try await coreDataManager.createEntityAsync(type: hangdamType)
            return dtoMapper.toDTO(from: newHangdam)
        }
    }

    func fetchHangdamsAsync() async throws -> [HangdamDTO] {
        let hangdams: [HangdamEntity] = try await coreDataManager.fetchEntitiesAsync(entityType: hangdamType).dropLast()

        return hangdams.compactMap { hangdam in
            dtoMapper.toDTO(from: hangdam)
        }
    }

    func nameHangdamAsync(id: String?, name: String) async throws {
        try await coreDataManager.performBackgroundTaskAsync { context in
            guard let id: NSManagedObjectID = IDConverter.toNSManagedObjectID(from: id, in: context) else {
                throw DataError.convertIDFailed
            }

            guard let hangdam: HangdamEntity = context.object(with: id) as? HangdamEntity else {
                throw DataError.backgroundTaskFailed
            }

            hangdam.name = name
        }
    }
}
