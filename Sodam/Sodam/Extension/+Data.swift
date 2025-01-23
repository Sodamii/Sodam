//
//  +Data.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import Foundation

extension Data {
    var toStringArray: [String]? {
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSArray.self, from: self) as? [String]
    }
}
