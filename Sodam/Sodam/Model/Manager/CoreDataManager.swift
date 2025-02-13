//
//  CoreDataManager.swift
//  Sodam
//
//  Created by EMILY on 22/01/2025.
//

import CoreData

// MARK: - CoreDataManager

final class CoreDataManager {
    static let shared = CoreDataManager()
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
            print("[CoreData] context 변경사항 저장 완료")
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
        /// dto를 entity로 매핑
        let mapper = HappinessMapper()
        let mapResult = mapper.toEntity(from: dto, context: context)
        
        switch mapResult {
        case .failure:
            /// toEntity 메소드 내부에 DataError를 출력하고 있어 더 처리 하지 않음 - 추후에 error handling 필요
            return
        case .success(let entity):
            /// 행담이에 추가
            appendHappiness(entity, to: hangdamID)
            
            print("[CoreData] 행복 생성 완료")
            saveContext()
        }
    }
    
    /// 행복한 기억을 행담이에 추가하는 메소드 - 내부 호출
    private func appendHappiness(_ entity: HappinessEntity, to hangamID: NSManagedObjectID) {
        guard let hangdam = searchHangdam(with: hangamID) else { return }
        hangdam.addToHappinesses(entity)
    }
    
    /// 행담이가 갖고 있는 행복한 기억들 호출
    func getHappinesses(of hangdamID: NSManagedObjectID) -> [HappinessEntity] {
        guard let hangdam = searchHangdam(with: hangdamID) else { return [] }
        
        /// 특정 행담이의 행복들 fetch
        let fetchRequest = NSFetchRequest<HappinessEntity>(entityName: CDKey.happinessEntity.rawValue)
        fetchRequest.predicate = NSPredicate(format: "hangdam == %@", hangdam)
        
        /// 행복을 날짜 내림차순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: CDKey.date.rawValue, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print(DataError.fetchRequestFailed.localizedDescription)
            return []
        }
    }
    
    /// 행복한 기억 단일 삭제
    func deleteHappiness(with id: NSManagedObjectID) {
        guard let entity = searchHappiness(with: id) else { return }
        context.delete(entity)
       
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
    func checkHappinessCount(with hangdamID: NSManagedObjectID) -> Int? {
        guard let hangdam = searchHangdam(with: hangdamID) else { return nil }
        return hangdam.happinesses?.count
    }
}

fileprivate enum CDKey: String {
    case container = "SodamContainer"
    case hangdamEntity = "HangdamEntity"
    case happinessEntity = "HappinessEntity"
    case date
}
