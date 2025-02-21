//
//  NSStringCacher.swift
//  Sodam
//
//  Created by 박진홍 on 2/21/25.
//

import UIKit

actor GenericCacher<Value: AnyObject> {
    private let cache: NSCache<NSString, Value> = NSCache<NSString, Value>()

    private var inflightRequests: [NSString: Task<Value?, Error>] = [:]

    init(countLimit: Int = 30) {
        self.cache.countLimit = countLimit
    }

    func getValueByKey(_ key: String?, operation: @escaping () async throws -> Value?) async throws ->  Value? {
        let key: NSString = try wrapStringToKey(key)
        
        if let cachedValue: Value = cache.object(forKey: key) {
            return cachedValue
        }

        if let existingTask: Task<Value?, Error> = inflightRequests[key] {
            return try await existingTask.value
        }

        let newTask: Task<Value?, Error> = Task<Value?, Error> {
            let value: Value? = try await operation()
            guard let value: Value = value else {
                throw CacheError.invalidValue
            }
            self.cache.setObject(value, forKey: key)
            return value
        }

        inflightRequests[key] = newTask
        defer { inflightRequests[key] = nil }
        
        return try await newTask.value
    }

    func removeValueByKey(_ key: String?) async throws {
        let key: NSString = try wrapStringToKey(key)
        cache.removeObject(forKey: key)
    }

    func removeAllValue() async {
        cache.removeAllObjects()
    }

    private func wrapStringToKey(_ string: String?) throws -> NSString {
        guard let key: String = string else {
            throw CacheError.invalidKey
        }
        return key as NSString
    }
}

enum CacheError: Error {
    case invalidKey
    case invalidValue
}
