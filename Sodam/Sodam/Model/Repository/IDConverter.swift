//
//  IDConverter.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import CoreData

/// Entity - DTO 간 변환 시 NSManagedObjectID - StringID 서로 변환하는 메소드 구현
enum IDConverter {
    static func toNSManagedObjectID(from id: String?, in context: NSManagedObjectContext) -> NSManagedObjectID? {
        guard let id = id,
              let url = URL(string: id),
              let convertedID = context.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url)
        else {
            print(DataError.convertIDFailed.localizedDescription)
            return nil
        }

        return convertedID
    }

    static func toStringID(from id: NSManagedObjectID?) -> String {
        guard let id = id else { return "" }
        return id.uriRepresentation().absoluteString
    }
}
