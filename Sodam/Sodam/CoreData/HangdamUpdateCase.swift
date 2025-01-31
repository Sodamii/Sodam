//
//  HangdamUpdateCase.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import Foundation

/// 행담이 entity의 어떤 attribute를 업데이트 해야하는지 분기해주는 값
enum HangdamUpdateCase {
    case name(String)
    case startDate(Date)
    case endDate(Date)
}
