//
//  StatusContentMapper.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

final class StatusContentMapper: ContentMapperProtocol {
    typealias Input = HangdamDTO
    typealias Output = StatusContent
    
    func map(from input: HangdamDTO) throws -> StatusContent {
        let level: Int = input.level
        
        let name: String = {
            if let name = input.name {
                return name
            } else {
                return "이름을 지어주세요."
            }
        }()
        
        let levelDescription: String = "Lv.\(input.level) \(input.levelName)"
        
        let dateDescription: String = {
            guard let startDate = input.startDate else {
                return ""
            }
            
            guard let endDate = input.endDate else {
                return "\(startDate) ~"
            }
            
            return "\(startDate) ~ \(endDate)"
        }()
        
        return StatusContent(
            level: level,
            name: name,
            levelDescription: levelDescription,
            dateDescription: dateDescription
        )
    }
}

