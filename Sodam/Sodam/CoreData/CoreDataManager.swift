//
//  CoreDataManager.swift
//  Sodam
//
//  Created by EMILY on 22/01/2025.
//

import CoreData

protocol HangdamManagingProtocol {
    var context: NSManagedObjectContext { get }
    
    func fetchHangdams() -> [HangdamEntity]
    func createHangdam() -> HangdamEntity
    func updateHangdam(with id: NSManagedObjectID, _ dto: HangdamDTO)
}

protocol HappinessManagingProtocol {
    
}

final class CoreDataManager: HangdamManagingProtocol, HappinessManagingProtocol {
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: CDKey.container.rawValue)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(DataError.containerLoadFailed.localizedDescription)
                print(error.localizedDescription)
            } else {
                print("[CoreData] container 로드 완료")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    /// context 저장 - 내부 호출
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let error {
            print(DataError.contextSaveFailed.localizedDescription)
            print(error.localizedDescription)
        }
    }
    
    /// context에 있는 모든 행담이 불러오기
    func fetchHangdams() -> [HangdamEntity] {
        let fetchRequest = NSFetchRequest<HangdamEntity>(entityName: CDKey.hangdamEntity.rawValue)
        
        do {
            let hangdams = try context.fetch(fetchRequest)
            return hangdams
        } catch let error {
            print(DataError.fetchRequestFailed.localizedDescription)
            print(error.localizedDescription)
            return []
        }
    }
    
    /// 행담이 새로 생성 : 모든 값이 빈 값
    func createHangdam() -> HangdamEntity {
        let entity = HangdamEntity(context: context)
        saveContext()
        print("[CoreData] 새로운 행담이 생성")
        return entity
    }
    
    /// 행담이 삭제 기능 아직 안 쓰지만 일단 구현함
    private func deleteHangdam(with id: NSManagedObjectID) {
        guard let entity = searchHangdam(with: id) else { return }
        context.delete(entity)
        print("[CoreData] 삭제 완료")
        saveContext()
    }
    
    /// 행담이 수정
    func updateHangdam(with id: NSManagedObjectID, _ dto: HangdamDTO) {
        guard let entity = searchHangdam(with: id) else { return }
        /// 현재 행담이 정보 업데이트는 이름 짓기 밖에 없으므로 이름 update만 구현
        entity.name = dto.name
        saveContext()
    }
    
    /// 행담이 검색 - 내부 호출
    private func searchHangdam(with id: NSManagedObjectID) -> HangdamEntity? {
        do {
            let hangdam = try context.existingObject(with: id) as? HangdamEntity
            return hangdam
        } catch let error {
            print(DataError.searchEntityFailed.localizedDescription)
            print(error.localizedDescription)
            return nil
        }
    }
}

fileprivate enum CDKey: String {
    case container = "SodamContainer"
    case hangdamEntity = "HangdamEntity"
    case happinessEntity = "HappinessEntity"
}
