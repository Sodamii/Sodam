//
//  HappinessRepository + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

import CoreData

extension HappinessRepository {
    func addHappinessAsync(happiness: HappinessDTO) async throws {
        guard let id: NSManagedObjectID = IDConverter.toNSManagedObjectID(from: happiness.hangdamID, in: coredataContext) else {
            throw DataError.convertIDFailed
        }
        
        self.updateHangdamIfNeeded(hangdamID: id)
        
        try await self.dtoMapper.toEntity(from: happiness, context: coredataContext).asyncFold { [weak self] happinessEntity in
            guard let self = self else { throw DataError.selfIsNil }
            let hangdamEntity: HangdamEntity = try await self.coreDataManager.fetchEntityByIdAsync(id: happiness.hangdamID, context: coredataContext)
            
            hangdamEntity.addToHappinesses(happinessEntity)
            
        } onFailure: { error in
            print(error.localizedDescription)
            throw error
        }
    }
    
    func fetchHappinessAsync(of HangdamId: String?) async throws -> [HappinessDTO] {
        let hangdamEntity: HangdamEntity = try await coreDataManager.fetchEntityByIdAsync(id: HangdamId, context: coredataContext)
        let predicate: NSPredicate = NSPredicate(format: "hangdam == %@", hangdamEntity)
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        
        let happiness: [HappinessEntity] = try await coreDataManager.fetchEntitiesAsync(entityType: happinessType, context: coredataContext, predicate: predicate, sortDescriptors: [sortDescriptor])
        
        return happiness.compactMap { happinessEntity in
            dtoMapper.toDTO(from: happinessEntity)
        }
    }
    
    func deleteHappinessAsync(with id: String?, path: String?) async throws {
        try await coreDataManager.deleteEntityByIdAsync(id: id, type: HappinessEntity.self, context: coredataContext)
        
        guard let path = path else { return }
        imageManager.deleteImage(path)
    }
}
