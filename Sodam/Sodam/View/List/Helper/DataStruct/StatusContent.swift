//
//  StatusS.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

import Foundation

struct StatusContent {
    let id: String
    let level: Int
    var name: String
    let levelDescription: String
    let dateDescription: String
    
    // 이름에서 "담이" 뺀 텍스트
    var nameText: String {
        name.hasSuffix("담이") ? String(name.dropLast(2)) : ""
    }
}
