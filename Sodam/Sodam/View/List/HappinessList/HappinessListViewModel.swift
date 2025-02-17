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
    @Published var title: String
    @Published var happinessCellStores: [HappinessCellStore]
    @Published var happinessDetailViewModels: [HappinessDetailViewModel]
    @Published var statusStore: HangdamStatusStore
    
    private let happinessRepository: HappinessRepository
    
    init(hangdam: HangdamDTO, happinessRepository: HappinessRepository = HappinessRepository()) {
        self.happinessRepository = happinessRepository
        self.title = "\(hangdam.name ?? "행담이")가 먹은 기억들"
        let dateDescription = if let startDate = hangdam.startDate {
            "\(startDate) ~ \(hangdam.endDate ?? "")"
        } else {
            ""
        }
        self.statusStore = HangdamStatusStore(
            image: .hangdamImage(level: hangdam.level),
            name: hangdam.name ?? "이름을 지어주세요!",
            description: "Lv.\(hangdam.level) \(hangdam.levelName)",
            dateDescription: dateDescription
        )
        let happinessList = happinessRepository.getHappinesses(of: hangdam.id)
        self.happinessCellStores = happinessList.map {
                HappinessCellStore(
                    image: happinessRepository.getThumbnailImage(from: $0.imagePaths.first),
                    content: $0.content,
                    date: $0.formattedDate
                )
            }
        self.happinessDetailViewModels = happinessList.map {
            HappinessDetailViewModel(
               happiness: $0,
               happinessRepository: happinessRepository
           )
        }
    }
    
    func reloadData() {
        let tabHelper: TabBarHelper = .init()
        if let tabBarController = tabHelper.getRootTabBarController(),
           tabBarController.selectedIndex == 1 {
            print("기록 탭 tapped")
            
            let hangdamRepository: HangdamRepository = .init()
            let hangdam = hangdamRepository.getCurrentHangdam()
            
            self.title = "\(hangdam.name ?? "행담이")가 먹은 기억들"
            let dateDescription = if let startDate = hangdam.startDate {
                "\(startDate) ~ \(hangdam.endDate ?? "")"
            } else {
                ""
            }
            self.statusStore = HangdamStatusStore(
                image: .hangdamImage(level: hangdam.level),
                name: hangdam.name ?? "이름을 지어주세요!",
                description: "Lv.\(hangdam.level) \(hangdam.levelName)",
                dateDescription: dateDescription
            )
            let happinessList = happinessRepository.getHappinesses(of: hangdam.id)
            self.happinessCellStores = happinessList.map {
                HappinessCellStore(
                    image: happinessRepository.getThumbnailImage(from: $0.imagePaths.first),
                    content: $0.content,
                    date: $0.formattedDate
                )
            }
            self.happinessDetailViewModels = happinessList.map {
                HappinessDetailViewModel(
                    happiness: $0,
                    happinessRepository: happinessRepository
                )
            }
        }
    }
}
