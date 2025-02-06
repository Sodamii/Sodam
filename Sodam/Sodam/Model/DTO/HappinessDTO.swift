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
    let date: Date          // view에 바인딩 할 때 toFormattedString으로 변환 필요
    let imagePaths: [String]
    let hangdamID: String
}

extension HappinessEntity {
    var toDTO: HappinessDTO? {
        guard let content = self.content,
              let date = self.date,
              let imagePaths = self.imagePaths?.toStringArray
        else {
            return nil
        }
        
        return HappinessDTO(
            id: IDConverter.toStringID(from: self.objectID),
            content: content,
            date: date,
            imagePaths: imagePaths,
            hangdamID: IDConverter.toStringID(from: self.hangdam?.objectID)
        )
    }
}
