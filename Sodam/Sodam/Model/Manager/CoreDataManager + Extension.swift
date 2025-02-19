//
//  CoreDataManager + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/19/25.
//

// 추상화되고 비동기적으로 동작하는 메서드 추가

import CoreData

extension CoreDataManager {

    func createEntityAsync<T: NSManagedObject>(type: T.Type) async throws-> T {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                let newEntity = T(context: context)
                do {
                    try context.save()
                    continuation.resume(returning: newEntity)
                } catch {
                    continuation.resume(throwing: DataError.contextSaveFailed)
                }
            }
        }
    }

    func fetchEntityByIdAsync<T: NSManagedObject>(id: NSManagedObjectID) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                guard let entity = context.object(with: id) as? T else {
                    return continuation.resume(throwing: DataError.fetchRequestFailed)
                }
                continuation.resume(returning: entity)
            }
        }
    }

    func fetchEntitiesAsync<T: NSManagedObject>(
        entityType type: T.Type,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) async throws -> [T] {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                let entityName: String = String(describing: type)
                let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = sortDescriptors
                
                do {
                    let entities: [T] = try context.fetch(fetchRequest)
                    continuation.resume(returning: entities)
                } catch {
                    continuation.resume(throwing: DataError.fetchRequestFailed)
                }
            }
        }
    }

    func deleteEntityByIdAsync<T: NSManagedObject>(id: NSManagedObjectID, type: T.Type) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                guard let entity = context.object(with: id) as? T else {
                    return continuation.resume(throwing: DataError.deleteEnitityFailed)
                }
                
                do {
                    context.delete(entity)
                    try context.save()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: DataError.deleteEnitityFailed)
                }
            }
        }
    }

    func performBackgroundTaskAsync<T>(operation: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            persistentContainer.performBackgroundTask { context in
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                do {
                    let result = try operation(context)
                    if context.hasChanges {
                        try context.save()
                    }
                    
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: DataError.backgroundTaskFailed)
                }
            }
        }
    }
}
