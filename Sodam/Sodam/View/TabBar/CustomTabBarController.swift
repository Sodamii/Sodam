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
        mainViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        mainViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        
        // 기록 탭
        let happinessListViewController = UIHostingController(rootView: HappinessListView(hangdam: mainViewModel.hangdam, isBackButtonHidden: true))
        happinessListViewController.tabBarItem = UITabBarItem(
            title: "기록",
            image: UIImage(named: "book"),
            selectedImage: UIImage(named: "book.fill"))
        happinessListViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        happinessListViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        
        // 설정 탭
        let settingViewModel = SettingViewModel()
        let settingsViewController = SettingsViewController(settingViewModel: settingViewModel)
        settingsViewController.tabBarItem = UITabBarItem(
            title: "설정",
            image: UIImage(named: "gear"),
            selectedImage: UIImage(named: "gear.fill"))
        settingsViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        settingsViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
        
        // 보관 탭
        let storageViewController = UIHostingController(rootView: HangdamStorageView(viewModel: storageViewModel))
        storageViewController.tabBarItem = UITabBarItem(
            title: "보관",
            image: UIImage(named: "archivebox"),
            selectedImage: UIImage(named: "archivebox.fill"))
        storageViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        storageViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)

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
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        
        // 선택된 상태의 색상과 Bold 폰트 설정
        appearance.stackedLayoutAppearance.selected.iconColor = .textAccent
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.textAccent,
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
