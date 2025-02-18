//
//  HappinessListConfigMapper.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

final class HappinessListConfigMapper: DataMapping {
    typealias Input = [HappinessDTO]
    
    typealias Output = [HappinessListConfig]
    
    func map(from input: [HappinessDTO]) -> [HappinessListConfig] {
        return input.map { happiness in
            HappinessListConfig(
                detailContentID: happiness.id,
                detailContent: HappinessDetailContent(
                    happinessContent: happiness.content,
                    happinessImagePath: happiness.imagePaths.first,
                    happinessDate: happiness.formattedDate
                ),
                cellContent: HappinessCellContent(
                    imagePath: happiness.imagePaths.first,
                    happinessContent: happiness.content,
                    date: happiness.formattedDate
                )
            )
        }
    }
}
