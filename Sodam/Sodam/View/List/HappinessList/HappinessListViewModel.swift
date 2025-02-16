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
    @Published var isDataError: Bool
    @Published var errorMessage: String?
    
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
        
        let result = listViewReloader.reloadData()
        switch result {
        case.success(let initialData):
            self.statusContent = statusContentMapper.map(from: initialData.hangdam)
            self.listContent = listContentMappper.map(from: initialData.hangdam)
            self.listConfigs = listConfigMapper.map(from: initialData.happiness)
            self.isCanDelete = (initialData.hangdam.endDate == nil ? false : true)
            self.isDataError = false
        case.failure(let error):
            self.statusContent = StatusContent(level: 0, name: "", levelDescription: "", dateDescription: "")
            self.listContent = HappinessListContent(title: "", emptyComment: "")
            self.listConfigs = []
            self.isCanDelete = false
            self.isDataError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
    func reloadData() {
        listViewReloader.reloadData().fold { initialData in
            self.statusContent = statusContentMapper.map(from: initialData.hangdam)
            self.listContent = listContentMappper.map(from: initialData.hangdam)
            self.listConfigs = listConfigMapper.map(from: initialData.happiness)
            self.isCanDelete = (initialData.hangdam.endDate == nil ? false : true)
            self.isDataError = false
        } onFailure: { error in
            self.statusContent = StatusContent(level: 0, name: "", levelDescription: "", dateDescription: "")
            self.listContent = HappinessListContent(title: "", emptyComment: "")
            self.listConfigs = []
            self.isCanDelete = false
            self.isDataError = true
        }
        print("[HappinessListViewModel] reloadeData 리로드")
    }
}
