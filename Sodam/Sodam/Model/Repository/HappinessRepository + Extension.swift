//
//  HappinessRepository + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

import UIKit
import CoreData

extension HappinessRepository {
    func addHappinessAsync(happiness: HappinessDTO) async throws {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let id: NSManagedObjectID = IDConverter.toNSManagedObjectID(
            from: happiness.hangdamID,
            in: coredataContext
        ) else {
            throw DataError.convertIDFailed
        }

        self.updateHangdamIfNeeded(hangdamID: id)

        try await self.dtoMapper
            .toEntity(from: happiness, context: coredataContext)
            .asyncFold { [weak self] happinessEntity in
            guard let self = self else { throw DataError.selfIsNil }
                let hangdamEntity: HangdamEntity = try await self.coreDataManager.fetchEntityByIdAsync(
                    id: happiness.hangdamID,
                    context: coredataContext
                )

            hangdamEntity.addToHappinesses(happinessEntity)

        } onFailure: { error in
            print(error.localizedDescription)
            throw error
        }
    }

    func fetchHappinessAsync(of hangdamId: String?) async throws -> [HappinessDTO] {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdamEntity: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(
            id: hangdamId,
            context: coredataContext
        )
        let predicate: NSPredicate = NSPredicate(format: "hangdam == %@", hangdamEntity)
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)

        let happiness: [HappinessEntity] = try await coreDataManager.fetchEntitiesAsync(
            context: coredataContext,
            predicate: predicate,
            sortDescriptors: [sortDescriptor]
        )

        return happiness.compactMap { happinessEntity in
            dtoMapper.toDTO(from: happinessEntity)
        }
    }

    func deleteHappinessAsync(with id: String?, path: String?) async throws {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        try await coreDataManager.deleteEntityByIdAsync(
            id: id,
            type: HappinessEntity.self,
            context: coredataContext
        )

        guard let path = path else { return }
        imageManager.deleteImage(path)
    }

    func updateHangdamIfNeededAsync(hangdamId: String?) async throws {
        let count: Int? = try await self.checkHappinessCountAsync(with: hangdamId)

        switch count {
        case 0:     // 행담이 startDate 업데이트, 레벨 1로 성장
            try await coreDataManager.performBackgroundTaskAsync { [weak self] context in
                guard let self = self else { throw DataError.selfIsNil }
                let hangdam: HangdamEntity = try await self.coreDataManager.fetchEntityByIdAsync(
                    id: hangdamId,
                    context: context
                )
                hangdam.startDate = Date.now
            }
            postNotification(level: 1)
        case 3:     // 행담이 레벨 2로 성장
            postNotification(level: 2)
        case 10:    // 행담이 레벨 3으로 성장
            postNotification(level: 3)
        case 24:    // 행담이 레벨 4로 성장
            postNotification(level: 4)
        case 29:    // 행담이 endDate 업데이트, 최종 성장(보관함 이동)
            try await coreDataManager.performBackgroundTaskAsync { [weak self] context in
                guard let self = self else { throw DataError.selfIsNil }
                let hangdam: HangdamEntity = try await self.coreDataManager.fetchEntityByIdAsync(
                    id: hangdamId,
                    context: context
                )
                hangdam.endDate = Date.now
            }
            postNotification(level: 5)
        default:
            return
        }
    }

    func checkHappinessCountAsync(with hangdamId: String?) async throws -> Int? {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdam: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(
            id: hangdamId,
            context: coredataContext
        )
        return hangdam.happinesses?.count
    }
    
    func getThumbnailImageAsync(from path: String?) async throws -> UIImage {
        return try await imageRepository.getThumbnailImage(from: path)
    }
}
