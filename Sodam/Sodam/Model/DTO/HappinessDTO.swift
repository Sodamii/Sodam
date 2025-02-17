//
//  HappinessDTO.swift
//  Sodam
//
//  Created by EMILY on 23/01/2025.
//

import Foundation

struct HappinessDTO: Hashable {
    var id: String?         // context에서 불러왔을 땐 id값이 있겠지만 사용자가 기록해서 entity로 변환하기 전에는 id가 없을 수도 있기 때문에 옵셔널
    let content: String     // 기억 수정 X
    let date: Date          // context에서 불러왔을 때 그대로 Date 타입 / writeview에서 행복 작성 시 now 값 할당하여 entity로 type 그대로 변환
    let imagePaths: [String]
    let hangdamID: String
    
    var formattedDate: String {     // view와 바인딩하기 위한 값
        return date.formatForHappiness
    }
}
