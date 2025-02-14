//
//  CustomTabBarController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit
import SwiftUI

final class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureViewController()
        setupTabBarAppearance()
        
        selectedIndex = 0 // 초기 화면을 mainVC로 설정
    }
    
    private func setupTabBar() {
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
    }
    
    private func configureViewController() {
        let hangdamRepository: HangdamRepository = HangdamRepository()
        let happinessRepository: HappinessRepository = HappinessRepository()
        let mainViewModel: MainViewModel = MainViewModel(repository: hangdamRepository)
        let storageViewModel: HangdamStorageViewModel = HangdamStorageViewModel(hangdamRepository: hangdamRepository)
        
        let detailViewOperator: DetailViewOperator = DetailViewOperator(happinessRepository: happinessRepository)
        let listViewReloader: ListViewReloader = ListViewReloader(happinessRepository: happinessRepository, hangdamRepository: hangdamRepository)
        let cellThumbnailFetcher: CellThumbnailFetcher = CellThumbnailFetcher(happinessRepository: happinessRepository)
        let mapperFactory: DataMapperFactory = DataMapperFactory()
        
        let listViewModel: HappinessListViewModel = HappinessListViewModel(
            detailViewOperator: detailViewOperator,
            listViewReloader: listViewReloader,
            cellThumbnailFetcher: cellThumbnailFetcher,
            mapperFactory: mapperFactory
        )
        
        // 메인 탭
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.tabBarItem = UITabBarItem(
            title: "메인",
            image: UIImage(named: "main"),
            selectedImage: UIImage(named: "main.fill"))
        
        // 기록 탭
        let happinessListViewController = UIHostingController(rootView: HappinessListView(viewModel: listViewModel, isBackButtonHidden: false))
        happinessListViewController.tabBarItem = UITabBarItem(
            title: "기록",
            image: UIImage(named: "book"),
            selectedImage: UIImage(named: "book.fill"))
        
        // 보관 탭
        let storageViewController = UIHostingController(rootView: HangdamStorageView(viewModel: storageViewModel))
        storageViewController.tabBarItem = UITabBarItem(
            title: "보관",
            image: UIImage(named: "archivebox"),
            selectedImage: UIImage(named: "archivebox.fill"))
        
        // 설정 탭
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingsViewController(settingViewModel: settingViewModel)
        settingsViewController.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(named: "gear"),
            selectedImage: UIImage(named: "gear.fill"))
        
        viewControllers = [mainViewController, happinessListViewController, storageViewController, settingsViewController]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBackground
        
        // 선택되지 않은 상태 스타일
        appearance.stackedLayoutAppearance.normal.iconColor = .viewBackground
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.viewBackground,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        
        // 선택된 상태 스타일
        appearance.stackedLayoutAppearance.selected.iconColor = .textAccent
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.textAccent,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        
        // SE 모델일 경우 타이틀 위치 조정
        if UIScreen.isiPhoneSE {
            appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
            appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -6)
        }
        
        // SE 모델일 경우 아이콘 위치 조정
        if UIScreen.isiPhoneSE {
            for item in tabBar.items ?? [] {
                item.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
                item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
            }
        }
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance  // 배경이 사라지지 않도록 설정함
    }
}
