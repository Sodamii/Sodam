//
//  CustomTabBarController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit
import SwiftUI

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        configureViewController()
        
        selectedIndex = 1                 // 초기 화면을 mainVC로 설정 배열에서 mainVC 인덱스 넣으면 됨
        
    }
    
    private func setupTabBar() {
        // Custom TabBar 설정
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        tabBar.tintColor = .primaryColor                       // 선택된 탭의 색
        tabBar.unselectedItemTintColor = .whiteColor         // 선택되지 않은 탭의 색
        tabBar.backgroundColor = .secondaryColor2
    }
    
    private func configureViewController() {
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "메인", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        let storageViewController = UIHostingController(rootView: HangdamStorageView())
        storageViewController.tabBarItem = UITabBarItem(title: "기록", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book.fill"))
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        
        viewControllers = [storageViewController, mainViewController, settingsViewController ]
    }
}
