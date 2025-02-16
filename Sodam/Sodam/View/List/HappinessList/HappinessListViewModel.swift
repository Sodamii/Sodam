//
//  HappinessListViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

// TODO: 에러 처리에 대한 구체적인 구현이 필요함.

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
    
    private let statusContentMapper: AnyDataMapper<HangdamDTO, StatusContent>
    private let listContentMapper: AnyDataMapper<HangdamDTO, HappinessListContent>
    private let listConfigMapper: AnyDataMapper<[HappinessDTO], [HappinessListConfig]>
    
    init(
        detailViewOperator: DetailViewOperator,
        listViewReloader: ListViewReloader,
        cellThumbnailFetcher: CellThumbnailFetcher,
        mapperFactory: DataMapperFactory
    ) {
        self.detailViewOperator = detailViewOperator
        self.listViewReloader = listViewReloader
        self.cellThumbnailFetcher = cellThumbnailFetcher
        
        do {
            self.statusContentMapper = try mapperFactory.createAnyMapper(inputType: HangdamDTO.self, outputType: StatusContent.self).get()
            self.listContentMapper = try mapperFactory.createAnyMapper(inputType: HangdamDTO.self, outputType: HappinessListContent.self).get()
            self.listConfigMapper = try mapperFactory.createAnyMapper(inputType: [HappinessDTO].self, outputType: [HappinessListConfig].self).get()
        } catch {
            fatalError("[ListViewModel] 매퍼 주입 실패") // 실패한 채로 실행되는 경우가 없게 개발단계에서 확실히 확인하도록 fatalError처리 해보았음.
        }
        
        let result = listViewReloader.reloadData()
        switch result {
        case.success(let initialData):
            self.statusContent = statusContentMapper.map(from: initialData.hangdam)
            self.listContent = listContentMapper.map(from: initialData.hangdam)
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
            self.listContent = listContentMapper.map(from: initialData.hangdam)
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
