//
//  HappinessCellViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 2/15/25.
//

import UIKit

final class HappinessCellViewModel {
    let content: HappinessCellContent
    let thumbnailFetcher: CellThumbnailFetcher
    
    init(content: HappinessCellContent, thumbnailFetcher: CellThumbnailFetcher) {
        self.content = content
        self.thumbnailFetcher = thumbnailFetcher
    }
    
    func getThumbnail() -> UIImage? {
        return thumbnailFetcher.fetchThumbnail(from: content.imagePath)
    }
}
