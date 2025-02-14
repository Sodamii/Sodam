//
//  HappinessListConfig.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

typealias HappinessID = String

struct HappinessListConfig: Hashable {
    let detailContentID: HappinessID?
    let detailContent: HappinessDetailContent
    let cellContent: HappinessCellContent
}
