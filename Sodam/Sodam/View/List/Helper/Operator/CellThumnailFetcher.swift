//
//  HappinessCell.swift
//  Sodam
//
//  Created by 박진홍 on 2/15/25.
//

import UIKit

protocol ThumbnailFetching {
    func fetchThumbnail(from path: String?) -> UIImage?
}

final class CellThumbnailFetcher: ThumbnailFetching {
    private let happinessRepository: HappinessRepository
    
    init(happinessRepository: HappinessRepository) {
        self.happinessRepository = happinessRepository
    }
    
    func fetchThumbnail(from path: String?) -> UIImage? {
        return happinessRepository.getThumbnailImage(from: path)
    }
}
