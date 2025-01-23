//
//  +Date.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import Foundation

extension Date {
    var toFormattedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
