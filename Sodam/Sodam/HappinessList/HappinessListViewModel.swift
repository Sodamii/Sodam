//
//  HappinessListViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

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
}

