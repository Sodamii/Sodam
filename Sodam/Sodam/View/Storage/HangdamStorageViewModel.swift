//
//  HangdamStorageViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//  Edited by EMILY on 10/02/2025.

import Combine

final class HangdamStorageViewModel: ObservableObject {
    @Published var storedHangdams: [HangdamDTO]
    
    private let hangdamRepository: HangdamRepository
    
    init(hangdamRepository: HangdamRepository) {
        self.hangdamRepository = hangdamRepository
        self.storedHangdams = hangdamRepository.getSavedHangdams()
    }
    
    func loadHangdams() {
        self.storedHangdams = hangdamRepository.getSavedHangdams()
    }
}
