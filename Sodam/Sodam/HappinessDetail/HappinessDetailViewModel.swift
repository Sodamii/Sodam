//
//  HappinessDetailViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/27/25.
//

import Combine
import UIKit
import Foundation

final class HappinessDetailViewModel {
    let happiness: HappinessDTO
    
    private let happinessRepository: HappinessRepository
    
    init(happiness: HappinessDTO,
         happinessRepository: HappinessRepository
    ) {
        self.happiness = happiness
        self.happinessRepository = happinessRepository
    }
    
    func deleteHappiness() {
        // TODO: happiness id가 없을 때 상세 처리 필요함.
        self.happinessRepository.deleteHappiness(with: self.happiness.id ?? "")
    }
    
    func getImage(from imagePath: String) -> UIImage {
        guard let image =  self.happinessRepository.getContentImage(from: imagePath)
        else {
            print("[HappinessDetailViewModel] getImage 메서드 동작 실패")
            return UIImage()
        }
        return image
    }
}
