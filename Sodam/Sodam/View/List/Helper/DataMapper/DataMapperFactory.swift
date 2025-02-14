//
//  ContentMapperFactory.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

final class DataMapperFactory {
    func createStatusMapper() -> StatusContentMapper {
        return StatusContentMapper()
    }
    
    func createHappinessListConfigMapper() -> HappinessListConfigMapper {
        return HappinessListConfigMapper()
    }
    
    func createHappinessListContentMapper() -> HappinessListContentMapper {
        return HappinessListContentMapper()
    }
}
