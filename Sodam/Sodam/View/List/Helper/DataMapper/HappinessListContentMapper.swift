//
//  HappinessListContentMapper.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

final class HappinessListContentMapper: DataMapping {
    typealias Input = HangdamDTO
    
    typealias Output = HappinessListContent
    
    func map(from input: HangdamDTO) -> HappinessListContent {
        let name: String = {
            guard let name = input.name else {
                return "행담이"
            }
            return name
        }()
        
        return HappinessListContent(
            title: "\(name)가 먹은 기억들",
            emptyComment: "아직 가진 기억이 없어요😢"
        )
    }
}
