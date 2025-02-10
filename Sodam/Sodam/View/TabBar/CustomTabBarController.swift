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
        let mainViewModel: MainViewModel = MainViewModel(repository: hangdamRepository)
        let storageViewModel: HangdamStorageViewModel = HangdamStorageViewModel(hangdamRepository: hangdamRepository)
        
        // 메인 탭
        let mainViewController = MainViewController(viewModel: mainViewModel)
        mainViewController.tabBarItem = UITabBarItem(
            title: "메인",
            image: UIImage(named: "main"),
            selectedImage: UIImage(named: "main.fill"))
        
        // 기록 탭
        let happinessListViewController = UIHostingController(rootView: HappinessListView(hangdam: mainViewModel.hangdam, isBackButtonHidden: true))
        happinessListViewController.tabBarItem = UITabBarItem(
            title: "기록",
            image: UIImage(named: "book"),
            selectedImage: UIImage(named: "book.fill"))
        
        // 설정 탭
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingsViewController(settingViewModel: settingViewModel)
        settingsViewController.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(named: "gear"),
            selectedImage: UIImage(named: "gear.fill"))
        
        // 보관 탭
        let storageViewController = UIHostingController(rootView: HangdamStorageView(viewModel: storageViewModel))
        storageViewController.tabBarItem = UITabBarItem(
            title: "보관",
            image: UIImage(named: "archivebox"),
            selectedImage: UIImage(named: "archivebox.fill"))

        viewControllers = [mainViewController, happinessListViewController, storageViewController, settingsViewController]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBackground
        
        // 탭바 높이가 기종마다 다를 경우 아이콘과 타이틀 위치도 자동으로 조정되게 비율로 설정.
        // 이렇게 하면 모든 기기에서 거의 일관된 UI 유지 가능
        let tabBarHeight = tabBar.frame.height
        let titleOffset = -(tabBarHeight * 0.05)
        _ = tabBarHeight * 0.05
        
        // 선택되지 않은 상태
        appearance.stackedLayoutAppearance.normal.iconColor = .viewBackground
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.viewBackground,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: titleOffset)
        
        // 선택된 상태
        appearance.stackedLayoutAppearance.selected.iconColor = .textAccent
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.textAccent,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: titleOffset)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance  // 배경이 사라지지 않도록 설정함
    }
}
