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
    private let hangdam: HangdamDTO
    
    init(happinessRepository: HappinessRepository, hangdam: HangdamDTO) {
        self.happinessRepository = happinessRepository
        self.hangdam = hangdam
    }
    
    func reloadData() -> ListViewReloadData {
        return (
            hangdam,
            happinessRepository.getHappinesses(
                of: hangdam.id
            )
        )
        
    }
}
