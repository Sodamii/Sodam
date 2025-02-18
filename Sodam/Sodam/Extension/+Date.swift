//
//  +Date.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import Foundation

/// Date 타입을 view에 바인딩하기 위해 String으로 변환
extension Date {
    var formatForHangdam: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    var formatForHappiness: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "d MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
