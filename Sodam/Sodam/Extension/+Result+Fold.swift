//
//  +Result+Fold.swift
//  Sodam
//
//  Created by 박진홍 on 2/16/25.
//

extension Result {
    func fold<T>(onSuccess: (Success) -> T, onFailure: (Failure) -> T) -> T {
        switch self {
        case .success(let value):
            return onSuccess(value)
        case .failure(let error):
            return onFailure(error)
        }
    }
}
