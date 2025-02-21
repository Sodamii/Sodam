//
//  NSStringCacher.swift
//  Sodam
//
//  Created by 박진홍 on 2/21/25.
//

import UIKit

actor GenericCacher<Value: AnyObject> {
    // NSString을 key로 Value에 지정된 Type을 담을 수 있는 캐시
    private let cache: NSCache<NSString, Value> = NSCache<NSString, Value>()
    // 이미 요청중인 작업이 있다면 대기 후 앞선 작업에 대한 처리 결과를 전파받기 위한 딕셔너리
    private var inflightRequests: [NSString: Task<Value, Error>] = [:]

    // 최대 캐시 개수 제한으로 추후 용량 및 TTL 등의 캐시 무효화 정책 추가 예정.
    init(countLimit: Int = 30) {
        self.cache.countLimit = countLimit
    }

    // cache 검사 -> in-flight rquest가 있는지 검사 -> 모두 없으면 전달받은 operation으로 Value 생성 및 반환
    func getValueByKey(_ key: String?, operation: @escaping () async throws -> Value) async throws ->  Value {
        // String을 key로 받는데 NSCache는 ObjectC기반이라 NSString이 필요해 변환함
        let key: NSString = try wrapStringToKey(key)
        // 이미 캐시된 데이터가 있다변 바로 반환 후 종료
        if let cachedValue: Value = cache.object(forKey: key) {
            return cachedValue
        }
        // 이미 해당 key로 요청된 작업이 진행 중이라면 해당 작업을 기다렸다가 결과를 같이 반환함
        // 비동기적으로 요청이 들어올 수 있기에 처리된 부분으로 중복된 작업을 막아줌
        if let existingTask: Task<Value, Error> = inflightRequests[key] {
            return try await existingTask.value
        }
        // 캐시된 데이터나 앞선 요청이 없다면 새로 작업을 생성함
        let newTask: Task<Value, Error> = Task<Value, Error> {
            let value: Value = try await operation()
            self.cache.setObject(value, forKey: key)
            return value
        }
        // 요청받은 key에 새로운 Task 할당
        inflightRequests[key] = newTask
        //defer는 함수가 종료된 뒤 실행되는 코드로 Task가 실행된 뒤 결과가 전파된 뒤에 task를 삭제함
        defer { inflightRequests[key] = nil }
        // 만들어둔 Task의 결과를 반환함
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

// TODO: 추후 더 상세한 에러 정보 전달을 위한 리팩터링 필요
enum CacheError: Error {
    case invalidKey
    case invalidValue
}
