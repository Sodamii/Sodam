//
//  HappinessRepository + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

import CoreData

extension HappinessRepository {
    func addNewHappiness(happiness: HappinessDTO) async throws {
        try await coreDataManager.performBackgroundTaskAsync { [weak self] context in
            guard let self = self else { throw DataError.selfIsNil }
            guard let id: NSManagedObjectID = IDConverter.toNSManagedObjectID(from: happiness.hangdamID, in: context) else {
                throw DataError.convertIDFailed
            }
            
            self.updateHangdamIfNeeded(hangdamID: id)
            
            try self.dtoMapper.toEntity(from: happiness, context: context).fold { happinessEntity in
                guard let hangdamEntity = try context.existingObject(with: id) as? HangdamEntity else {
                    throw DataError.searchEntityFailed
                }
                
                hangdamEntity.addToHappinesses(happinessEntity)
                
            } onFailure: { error in
                print(error.localizedDescription)
                throw error
            }
        }
    }
}
