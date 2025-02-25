//
//  HappinessListViewReloder.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

import Foundation

typealias ListViewConfigData = (hangdam: HangdamDTO, happiness: [HappinessDTO])

protocol ListViewReloading {
    func reloadData() async throws -> ListViewConfigData
}

final class ListViewReloader: ListViewReloading {
    private let happinessRepository: HappinessRepository
    private let hangdamRepository: HangdamRepository
    private let hangdamID: String?
    
    init(happinessRepository: HappinessRepository, hangdamRepository: HangdamRepository, hangdamID: String?) {
        self.happinessRepository = happinessRepository
        self.hangdamRepository = hangdamRepository
        self.hangdamID = hangdamID
    }
    
    func reloadData() async throws -> ListViewConfigData {
        let newHangdamData: HangdamDTO = try await hangdamRepository.fetchHangdamByIdAsync(id: hangdamID)
        let happiness: [HappinessDTO] = try await happinessRepository.fetchHappinessAsync(of: hangdamID)
        print("[\((#file as NSString).lastPathComponent)] [\(#function): \(#line)] - 데이터 로드 완료")
        return (newHangdamData, happiness)
    }
}

final class CurrentListViewReloader: ListViewReloading {
    private let happinessRepository: HappinessRepository
    private let hangdamRepository: HangdamRepository
    
    init(happinessRepository: HappinessRepository, hangdamRepository: HangdamRepository) {
        self.happinessRepository = happinessRepository
        self.hangdamRepository = hangdamRepository
    }
    
    func reloadData() async throws -> ListViewConfigData {
        let hangdamID: String? = try await hangdamRepository.fetchCurrentHangdmaAsync().id
        let newHangdamData: HangdamDTO = try await hangdamRepository.fetchHangdamByIdAsync(id: hangdamID)
        let happiness: [HappinessDTO] = try await happinessRepository.fetchHappinessAsync(of: hangdamID)
        print("[\((#file as NSString).lastPathComponent)] [\(#function): \(#line)] - 데이터 로드 완료")
        return (newHangdamData, happiness)
    }
}
