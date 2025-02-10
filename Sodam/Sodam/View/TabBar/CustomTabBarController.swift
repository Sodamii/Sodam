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
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
        
        // 기록 탭
        let happinessListViewController = UIHostingController(rootView: HappinessListView(hangdam: mainViewModel.hangdam, isBackButtonHidden: true))
        happinessListViewController.tabBarItem = UITabBarItem(
            title: "기록",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill"))
        
        // 보관 탭
        let storageViewController = UIHostingController(rootView: HangdamStorageView(viewModel: storageViewModel))
        storageViewController.tabBarItem = UITabBarItem(
            title: "보관",
            image: UIImage(systemName: "archivebox"),
            selectedImage: UIImage(systemName: "archivebox.fill"))
        
        // 설정 탭
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingsViewController(settingViewModel: settingViewModel)
        settingsViewController.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear.fill"))

        viewControllers = [mainViewController, happinessListViewController, storageViewController, settingsViewController]

    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .tabBackground
        
        // 선택되지 않은 상태의 색상과 폰트 설정
        appearance.stackedLayoutAppearance.normal.iconColor = .viewBackground
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.viewBackground,
            .font: UIFont.systemFont(ofSize: 10)
        ]
        
        // 선택된 상태의 색상과 Bold 폰트 설정
        appearance.stackedLayoutAppearance.selected.iconColor = .textAccent
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.textAccent,
            .font: UIFont.boldSystemFont(ofSize: 11)  // Bold 폰트 지정
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
