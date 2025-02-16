//
//  HangdamStorageViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//  Edited by EMILY on 10/02/2025.

import Combine

final class HangdamStorageViewModel: ObservableObject {
    
    @Published var hangdamGridStores: [HangdamGridStore] = []
    @Published var happinessListViewModels: [HappinessListViewModel] = []
    
    private let hangdamRepository: HangdamRepository
    
    init(hangdamRepository: HangdamRepository) {
        self.hangdamRepository = hangdamRepository
        loadHangdams()
    }
    
    func loadHangdams() {
        let hangdams = hangdamRepository.getSavedHangdams()

        self.hangdamGridStores = hangdams.map { hangdamDTO in
            guard let name = hangdamDTO.name,
                  let startDate = hangdamDTO.startDate,
                  let endDate = hangdamDTO.endDate
            else { return HangdamGridStore(name: "이름잃은담이", dateString: "") }
            
            return HangdamGridStore(name: name, dateString: "\(startDate) ~ \(endDate)")
        }
        
        self.happinessListViewModels = hangdams.map { hangdamDTO in
            // TODO: DI컨테이너를 만들어서 의존성 주입에 대한 개선 필요
            let hangdamRepository: HangdamRepository = HangdamRepository()
            let happinessRepository: HappinessRepository = HappinessRepository()
            let mainViewModel: MainViewModel = MainViewModel(repository: hangdamRepository)
            let storageViewModel: HangdamStorageViewModel = HangdamStorageViewModel(hangdamRepository: hangdamRepository)
            
            let detailViewOperator: DetailViewOperator = DetailViewOperator(happinessRepository: happinessRepository)
            let listViewReloader: ListViewReloader = ListViewReloader(
                happinessRepository: happinessRepository,
                hangdamRepository: hangdamRepository,
                hangdamID: hangdamDTO.id
            )
            let cellThumbnailFetcher: CellThumbnailFetcher = CellThumbnailFetcher(happinessRepository: happinessRepository)
            let mapperFactory: DataMapperFactory = DataMapperFactory()
            
            return HappinessListViewModel(
                detailViewOperator: detailViewOperator,
                listViewReloader: listViewReloader,
                cellThumbnailFetcher: cellThumbnailFetcher,
                mapperFactory: mapperFactory
            )
        }
    }
}

struct HangdamGridStore {
    let name: String
    let dateString: String
}
