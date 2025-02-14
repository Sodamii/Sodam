//
//  HappinessListViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Foundation
import Combine
import UIKit

final class HappinessListViewModel: ObservableObject {
    @Published var hangdam: HangdamDTO
    @Published var happinessList: [HappinessDTO]
    
    private let happinessRepository: HappinessRepository
    private let hangdamRepository: HangdamRepository
    
    init(happinessRepository: HappinessRepository = HappinessRepository(),
         hangdamRepository: HangdamRepository = HangdamRepository()
    ) {
        self.happinessRepository = happinessRepository
        self.hangdamRepository = hangdamRepository
        self.hangdam = hangdamRepository.getCurrentHangdam()
        self.happinessList = happinessRepository.getHappinesses(of: hangdamRepository.getCurrentHangdam().id)
    }
    
    func reloadData() {
        let newHangdam = hangdamRepository.getCurrentHangdam()
        let newHappinesslist = happinessRepository.getHappinesses(of: hangdam.id)
        self.happinessList = newHappinesslist
        self.hangdam = newHangdam
        print("[HappinessListViewModel] reloadeData 리로드")
    }
    
    func getHappinessRepository() -> HappinessRepository {
        return self.happinessRepository
    }
    
    func getThumnail(from path: String?) -> UIImage? {
        return self.happinessRepository.getThumbnailImage(from: path)
    }
}
