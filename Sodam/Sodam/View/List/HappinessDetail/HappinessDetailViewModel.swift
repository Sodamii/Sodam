//
//  HappinessDetailViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/27/25.
//

import Combine
import UIKit
import Foundation

final class HappinessDetailViewModel: ObservableObject {
    let id: HappinessID?
    let isCurrentHangdam: Bool
    @Published var content: HappinessDetailContent
    private let detailViewOperator: DetailViewOperator

    init(id: HappinessID?, isCurrentHangdam: Bool, content: HappinessDetailContent, detailViewOperator: DetailViewOperator) {
        self.id = id
        self.isCurrentHangdam = isCurrentHangdam
        self.content = content
        self.detailViewOperator = detailViewOperator
    }

    func deleteHappiness() {
        self.detailViewOperator.deleteContent(id: id, path: content.happinessImagePath)
    }

    func getImage(from imagePath: String) -> UIImage {
        guard let image = detailViewOperator.fetchImage(from: content.happinessImagePath)
        else {
            print("[HappinessDetailViewModel] getImage 메서드 동작 실패")
            return UIImage()
        }
        return image
    }
}
