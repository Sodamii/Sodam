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

final class HappinessListViewModel: ObservableObject { // 기본값 넣어주는 static method 고민해보기
    @Published var statusContent: StatusContent = StatusContent(level: 0, name: "", levelDescription: "", dateDescription: "")
    @Published var listContent: HappinessListContent = HappinessListContent(title: "", emptyComment: "")
    @Published var listConfigs: [HappinessListConfig] = []
    @Published var isCanDelete: Bool = false
    @Published var isDataError: Bool = false
    @Published var errorMessage: String?
    
    let detailViewOperator: DetailViewOperator
    let listViewReloader: ListViewReloading
    let cellThumbnailFetcher: CellThumbnailFetcher
    
    private let statusContentMapper: ViewDataMapper<HangdamDTO, StatusContent>
    private let listContentMapper: ViewDataMapper<HangdamDTO, HappinessListContent>
    private let listConfigMapper: ViewDataMapper<[HappinessDTO], [HappinessListConfig]>
    
    private var detailViewModelCache: [HappinessID: HappinessDetailViewModel] = [:] // 만들어진 뷰모델이 있을 때 재사용
    
    init(
        detailViewOperator: DetailViewOperator,
        listViewReloader: ListViewReloading,
        cellThumbnailFetcher: CellThumbnailFetcher,
        mapperFactory: DataMapperFactory
    ) {
        self.detailViewOperator = detailViewOperator
        self.listViewReloader = listViewReloader
        self.cellThumbnailFetcher = cellThumbnailFetcher
        
        do {
            self.statusContentMapper = try mapperFactory.createAnyMapper(
                inputType: HangdamDTO.self,
                outputType: StatusContent.self
            ).get()
            self.listContentMapper = try mapperFactory.createAnyMapper(
                inputType: HangdamDTO.self,
                outputType: HappinessListContent.self
            ).get()
            self.listConfigMapper = try mapperFactory.createAnyMapper(
                inputType: [HappinessDTO].self,
                outputType: [HappinessListConfig].self
            ).get()
        } catch {
            fatalError("[ListViewModel] 매퍼 주입 실패") // 실패한 채로 실행되는 경우가 없게 개발단계에서 확실히 확인하도록 fatalError처리 해보았음.
        }
        
        Task { [weak self] in
            await self?.reloadData()
        }
        print("[\((#file as NSString).lastPathComponent)] [\(#function): \(#line)] - 초기화 완료")
    }
    
    /// DetailViewModel을 생성 추후 팩토리로 별도 분리 필요함
    func detailViewModel(for config: HappinessListConfig) -> HappinessDetailViewModel {
        if let id = config.detailContentID {
            if let cached = detailViewModelCache[id] {
                return cached
            } else {
                let detailViewModel = HappinessDetailViewModel(
                    id: id,
                    isCanDelete: self.isCanDelete,
                    content: config.detailContent,
                    detailViewOperator: self.detailViewOperator
                )
                detailViewModelCache[id] = detailViewModel
                return detailViewModel
            }
        } else { // 에러 처리 필요할 듯
            return HappinessDetailViewModel(
                id: nil,
                isCanDelete: self.isCanDelete,
                content: config.detailContent,
                detailViewOperator: self.detailViewOperator
            )
        }
    }
    
    func reloadData() async {
        do {
            let result: ListViewConfigData = try await listViewReloader.reloadData()
            
            await MainActor.run { // task main actor 알아보기 매퍼를 나누지 말고 매핑을 해주는 하나의 객체로 처리할 수 있는 방법도.
                self.statusContent = statusContentMapper.map(from: result.hangdam)
                self.listContent = listContentMapper.map(from: result.hangdam)
                self.listConfigs = listConfigMapper.map(from: result.happiness)
                self.isCanDelete = (result.hangdam.endDate == nil ? false : true)
                self.isDataError = false
                print("[\((#file as NSString).lastPathComponent)] [\(#function): \(#line)] - 리로드 완료")
            }
        } catch {
            self.isDataError = true
            self.errorMessage = error.localizedDescription
        }
    }
}
