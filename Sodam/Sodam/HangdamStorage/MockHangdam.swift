//
//  MockHangdam.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import Foundation

struct MockHangdam {
    let name: String
    let startDate: Date?
    let endDate: Date?
    let happiness: [MockHappiness] = MockHappiness.mockHappinesses
    
    var level: Int {
        switch happiness.count {
        case 1...9: return 1
        case 10...24: return 2
        case 25...29: return 3
        case 30: return 4       // level 4 : 성장완료 보관 ㄱ
        default: return 0
        }
    }
    
    static let mockHangdam = MockHangdam(name: "멍담이", startDate: Date.now - 86400, endDate: nil)
}

struct MockHappiness: Identifiable {
    let id: UUID = .init()
    var imagePaths: [String]?
    let content: String
    let tag: Tag?
    let date: Date
    
    static let mockHappinesses: [MockHappiness] = [
        MockHappiness(content: "오늘은 엽떡을 먹었다.", tag: nil, date: Date.now - 86400),
        MockHappiness(content: "오늘은 레드콤보를 먹었다.", tag: nil, date: Date.now - 172800),
        MockHappiness(content: "오늘은 맥날을 먹었다.", tag: nil, date: Date.now - 259200)
    ]
}

enum Tag {
    
}
