//
//  +Result+Fold.swift
//  Sodam
//
//  Created by 박진홍 on 2/16/25.
//

extension Result {
    func fold<T>(onSuccess: (Success) throws-> T, onFailure: (Failure) throws -> T) rethrows -> T {
        switch self {
        case .success(let value):
            return try onSuccess(value)
        case .failure(let error):
            return try onFailure(error)
        }
    }
}
