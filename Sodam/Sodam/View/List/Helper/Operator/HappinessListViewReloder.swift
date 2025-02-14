//
//  HappinessListViewReloder.swift
//  Sodam
//
//  Created by 박진홍 on 2/14/25.
//

typealias ListViewReloadData = (hangdam: HangdamDTO, happiness: [HappinessDTO])
protocol ListViewReloading {
    func reloadData() -> ListViewReloadData
}

final class ListViewReloader: ListViewReloading {
    private let happinessRepository: HappinessRepository
    private let hangdamRepository: HangdamRepository
    
    init(happinessRepository: HappinessRepository, hangdamRepository: HangdamRepository) {
        self.happinessRepository = happinessRepository
        self.hangdamRepository = hangdamRepository
    }
    
    func reloadData() -> ListViewReloadData {
        return (
            hangdamRepository.getCurrentHangdam(),
            happinessRepository.getHappinesses(
                of: hangdamRepository.getCurrentHangdam().id
            )
        )
        
    }
}
