//
//  HappinessListViewReloder.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

typealias ListViewConfigData = (hangdam: HangdamDTO, happiness: [HappinessDTO])

protocol ListViewReloading {
    func reloadData() -> Result<ListViewConfigData, Error>
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
    
    func reloadData() -> Result<ListViewConfigData, Error> {
        do {
            let newHangdamData: HangdamDTO = try hangdamRepository.fetchHangdamByID(by: self.hangdamID).get()
            return .success((
                newHangdamData,
                happinessRepository.getHappinesses(of: hangdamID)
            ))
        } catch {
            return .failure(error)
        }
    }
}
