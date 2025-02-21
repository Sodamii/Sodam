//
//  HangdamRepository + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

import CoreData

extension HangdamRepository {
    func fetchHangdamByIdAsync(id: String?) async throws -> HangdamDTO {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdam: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(
            id: id,
            context: coredataContext
        )
        return dtoMapper.toDTO(from: hangdam)
    }

    func fetchCurrentHangdmaAsync() async throws -> HangdamDTO {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdams: [HangdamEntity] = try await coreDataManager.fetchEntitiesAsync(
            context: coredataContext
        )

        if let currentHangdam: HangdamEntity = hangdams.last,
           currentHangdam.endDate == nil {
            return dtoMapper.toDTO(from: currentHangdam)
        } else {
            let newHangdam: HangdamEntity = try await coreDataManager.createEntityAsync(
                context: coredataContext
            )
            return dtoMapper.toDTO(from: newHangdam)
        }
    }

    func fetchHangdamsAsync() async throws -> [HangdamDTO] {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdams: [HangdamEntity] = try await coreDataManager.fetchEntitiesAsync(
            context: coredataContext
        ).dropLast()

        return hangdams.compactMap { hangdam in
            dtoMapper.toDTO(from: hangdam)
        }
    }

    func nameHangdamAsync(id: String?, name: String) async throws {
        let coredataContext: NSManagedObjectContext = coreDataManager.persistentContainer.newBackgroundContext()
        coredataContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let hangdam: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(
            id: id,
            context: coredataContext
        )
        hangdam.name = name

        try coredataContext.save()
    }
}
