//
//  +Data.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import Foundation

/// CoreData에 Data 타입으로 저장되어 있는 imagePaths를 [String]으로 변환
extension Data {
    var toStringArray: [String]? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: self) as? [String]
    }
}
