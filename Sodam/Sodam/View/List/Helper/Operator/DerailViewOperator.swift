//
//  DerailViewOperations.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

import UIKit

protocol  HappinessImageFetching {
    func fetchImage(from path: String?) -> UIImage?
}

protocol HappinessContentDeleting {
    func deleteContent(id: String?, path: String?)
}

final class DetailViewOperator: HappinessImageFetching, HappinessContentDeleting {
    private let happinessRepository: HappinessRepository

    init(happinessRepository: HappinessRepository) {
        self.happinessRepository = happinessRepository
    }

    func fetchImage(from path: String?) -> UIImage? {
        return happinessRepository.getContentImage(from: path)
    }

    func deleteContent(id: String?, path: String?) {
        happinessRepository.deleteHappiness(with: id, path: path)
    }
}
