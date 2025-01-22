//
//  +Array.swift
//  Sodam
//
//  Created by t2023-m0019 on 1/22/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
