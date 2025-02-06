//
//  HangdamStorageViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Combine

final class HangdamStorageViewModel: ObservableObject {
    @Published var currentHangdam: HangdamDTO
    @Published var storedHangdamList: [HangdamDTO]
    
    private let hangdamRepository: HangdamRepository
    
    init(hangdamRepository: HangdamRepository) {
        self.hangdamRepository = hangdamRepository
        self.currentHangdam = hangdamRepository.getCurrentHangdam()
        self.storedHangdamList = hangdamRepository.getSavedHangdams()
    }
    
    func loadHangdamData() {
        self.currentHangdam = hangdamRepository.getCurrentHangdam()
        self.storedHangdamList = hangdamRepository.getSavedHangdams()
    }
}
