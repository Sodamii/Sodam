//
//  HappinessListViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Foundation
import Combine

final class HappinessListViewModel: ObservableObject {
    @Published var hangdam: HangdamDTO
    @Published var happinessList: [HappinessDTO]?
    
    private let happinessRepository: HappinessRepository
    
    init(hangdam: HangdamDTO, happinessRepository: HappinessRepository = HappinessRepository()) {
        self.hangdam = hangdam
        self.happinessRepository = happinessRepository
        self.happinessList = happinessRepository.getHappinesses(of: hangdam.id)
    }
    
    func reloadData() {
        let newHappinesslist = happinessRepository.getHappinesses(of: hangdam.id)
        DispatchQueue.main.async {
            self.happinessList = newHappinesslist
        }
        print("1차 리로드")
        for happiness in happinessList ?? [] {
            print(happiness.content)
        }
        
        print("2차 리로드")
        for happiness in happinessList ?? [] {
            print(happiness.content)
        }
        
        // TODO: Store에 다녀오기 전까지 Repository에서 가져오는 것에도 반영이 안 됨.
        print("reload 완료")
    }
}

