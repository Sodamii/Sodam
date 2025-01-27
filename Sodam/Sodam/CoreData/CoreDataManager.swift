//
//  CoreDataManager.swift
//  Sodam
//
//  Created by EMILY on 22/01/2025.
//

import CoreData

// MARK: - CoreDataManager

final class CoreDataManager {
    private let persistentContainer: NSPersistentContainer
    
    init() {
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
            print("컨텍스트 변경사항 저장 완료")
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
        print("[CoreData] 행담이 삭제 완료")
        saveContext()
    }
    
    /// 행담이 수정 : update case에 따라 특정 attribute 수정
    func updateHangdam(with id: NSManagedObjectID, updateCase: HangdamUpdateCase) {
        guard let entity = searchHangdam(with: id) else { return }
        
        switch updateCase {
        case .name(let name):
            entity.name = name
        case .startDate(let date):
            entity.startDate = date
        case .endDate(let date):
            entity.endDate = date
        case .level(let level):
            entity.level = Int16(level)
        }

        print("[CoreData] 행담이 정보 업데이트 완료")
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
    
    /// 행복한 기억 생성 : 행담이 id 받아 행담이에 추가
    func createHappiness(_ dto: HappinessDTO, to hangdamID: NSManagedObjectID) {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: dto.imagePaths, requiringSecureCoding: true)
        else {
            print(DataError.convertImagePathsFailed.localizedDescription)
            return
        }
        
        let entity = HappinessEntity(context: context)
        entity.content = dto.content
        entity.date = dto.date
        entity.imagePaths = data
        
        /// 행담이에 추가
        appendHappiness(entity, to: hangdamID)
        
        print("[CoreData] 행복 생성 완료")
        saveContext()
    }
    
    /// 행복한 기억을 행담이에 추가하는 메소드 - 내부 호출
    private func appendHappiness(_ entity: HappinessEntity, to hangamID: NSManagedObjectID) {
        guard let hangdam = searchHangdam(with: hangamID)
        else {
            print(DataError.searchEntityFailed.localizedDescription)
            return
        }
        
        hangdam.addToHappinesses(entity)
    }
    
    /// 행담이가 갖고 있는 행복한 기억들 호출
    func getHappinesses(of hangdamID: NSManagedObjectID) -> [HappinessEntity]? {
        guard let hangdam = searchHangdam(with: hangdamID)
        else {
            print(DataError.searchEntityFailed.localizedDescription)
            return nil
        }
        
        return hangdam.happinesses?.array as? [HappinessEntity]
    }
    
    /// 행복한 기억 단일 삭제
    func deleteHappiness(with id: NSManagedObjectID) {
//        guard let entity = searchHappiness(with: id) else { return }
//        context.delete(entity)
        // TODO: 기존 메서드 방식으로는 context에 변경사항이 안 생겨서 save 메서드 또한 실행이 안 되길래 제가 쓰는 방식으로 바꾸었습니다.
        let happiness = context.object(with: id)
        context.delete(happiness)
       
        print("[CoreData] 행복 삭제 완료")
        saveContext()
    }
    
    /// 행복한 기억 검색 - 내부 호출
    private func searchHappiness(with id: NSManagedObjectID) -> HappinessEntity? {
        do {
            let happiness = try context.existingObject(with: id) as? HappinessEntity
            return happiness
        } catch let error {
            print(DataError.searchEntityFailed.localizedDescription)
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 행담이가 가진 현재 기억 개수 체크 - startDate, endDate 업데이트 기준으로 사용
    // MARK: level up event 처리를 할 거라면, 이 값에 대한 observing 필요
    func checkHappinessCount(with hangdamID: NSManagedObjectID) -> Int? {
        guard let hangdam = searchHangdam(with: hangdamID) else { return nil }
        return hangdam.happinesses?.count
    }
}

fileprivate enum CDKey: String {
    case container = "SodamContainer"
    case hangdamEntity = "HangdamEntity"
    case happinessEntity = "HappinessEntity"
}
