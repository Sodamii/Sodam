//
//  +Array.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
