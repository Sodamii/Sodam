//
//  HappinessRepository.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import Foundation

/// CoreDataManager와 ViewModel 사이에서 행복한 기억 데이터 처리를 맡는 객체
final class HappinessRepository {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager()) {
        self.coreDataManager = coreDataManager
    }
    
    /// 행복한 기억 생성
    func createHappiness(_ happiness: HappinessDTO) {
        guard let hangdamID = IDConverter.toNSManagedObjectID(from: happiness.hangdamID, in: coreDataManager.context)
        else {
            print(DataError.convertIDFailed.localizedDescription)
            return
        }
        
        /// 날짜 업데이트 필요성 체크
        updateHangdamIfNeeded(hangdamID: happiness.hangdamID)
        
        /// 기억생성
        coreDataManager.createHappiness(happiness, to: hangdamID)
    }
    
    /// 행담이 레벨이 0이거나 기억이 30개째가 될 경우 startDate 또는 endDate 업데이트
    private func updateHangdamIfNeeded(hangdamID: String) {
        guard let hangdamID = IDConverter.toNSManagedObjectID(from: hangdamID, in: coreDataManager.context),
              let count = coreDataManager.checkHappinessCount(with: hangdamID)
        else {
            print(DataError.convertIDFailed.localizedDescription)
            return
        }
        
        switch count {
        case 0:
            coreDataManager.updateHangdam(with: hangdamID, updateCase: .startDate(Date.now))
        case 29:
            coreDataManager.updateHangdam(with: hangdamID, updateCase: .endDate(Date.now))
        default:
            return
        }
    }
    
    /// 행담이가 가진 기억들 호출
    func getHappinesses(of hangdamID: String) -> [HappinessDTO]? {
        guard let id = IDConverter.toNSManagedObjectID(from: hangdamID, in: coreDataManager.context) else { return nil }
        
        return coreDataManager.getHappinesses(of: id)?.compactMap { $0.toDTO }
    }
    
    /// 기억 삭제
    func deleteHappiness(with id: String) {
        guard let id = IDConverter.toNSManagedObjectID(from: id, in: coreDataManager.context) else { return }
        
        coreDataManager.deleteHappiness(with: id)
    }
}
