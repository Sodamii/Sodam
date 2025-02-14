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
    @Published var statusContent: StatusContent
    @Published var listContent: HappinessListContent
    @Published var listConfigs: [HappinessListConfig]
    @Published var isCanDelete: Bool
    
    let detailViewOperator: DetailViewOperator
    let listViewReloader: ListViewReloader
    let cellThumbnailFetcher: CellThumbnailFetcher
    
    private let statusContentMapper: StatusContentMapper
    private let listContentMappper: HappinessListContentMapper
    private let listConfigMapper: HappinessListConfigMapper
    
    init(
        detailViewOperator: DetailViewOperator,
        listViewReloader: ListViewReloader,
        cellThumbnailFetcher: CellThumbnailFetcher,
        mapperFactory: DataMapperFactory
    ) {
        self.detailViewOperator = detailViewOperator
        self.listViewReloader = listViewReloader
        self.cellThumbnailFetcher = cellThumbnailFetcher
        
        self.statusContentMapper = mapperFactory.createStatusMapper()
        self.listContentMappper = mapperFactory.createHappinessListContentMapper()
        self.listConfigMapper = mapperFactory.createHappinessListConfigMapper()
        
        let initialData: ListViewReloadData = listViewReloader.reloadData()
        
        self.statusContent = statusContentMapper.map(from: initialData.hangdam)
        self.listContent = listContentMappper.map(from: initialData.hangdam)
        self.listConfigs = listConfigMapper.map(from: initialData.happiness)
        self.isCanDelete = (initialData.hangdam.endDate == nil ? false : true)
    }
    
    func reloadData() {
        let reloadData: ListViewReloadData = listViewReloader.reloadData()
        
        let newHappinesslist: [HappinessDTO] = reloadData.happiness
        let newHangdam: HangdamDTO = reloadData.hangdam
        
        self.statusContent = statusContentMapper.map(from: newHangdam)
        self.listContent = listContentMappper.map(from: newHangdam)
        self.listConfigs = listConfigMapper.map(from: newHappinesslist)
        self.isCanDelete = (newHangdam.endDate == nil ? false : true)

        print("[HappinessListViewModel] reloadeData 리로드")
    }
}
