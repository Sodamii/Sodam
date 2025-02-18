//
//  TabBarHelper.swift
//  Sodam
//
//  Created by EMILY on 16/02/2025.
//

import Foundation
import UIKit
import SwiftUI

final class TabBarHelper {
    /// HappinessListView가 기록 탭에서는 탭 바가 보여야하고, 보관 탭에서 네비게이션 stack에 쌓이면 탭 바를 숨겨야 함
    func setTabBarVisibilityByTab() {
        withAnimation {
            guard let tabBarController = getRootTabBarController() else { return }

            switch tabBarController.selectedIndex {
            case 2:
                tabBarController.tabBar.isHidden = true
            default:
                tabBarController.tabBar.isHidden = false
            }
        }
    }

    /// 파라미터의 bool 값에 따라 tabbar를 보이고/숨기는 메소드
    func setTabBarVisibility(_ isVisible: Bool) {
        withAnimation {
            if let tabBarController = getRootTabBarController() {
                tabBarController.tabBar.isHidden = !isVisible
            }
        }
    }

    func getRootTabBarController() -> UITabBarController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let rootViewController = sceneDelegate.window?.rootViewController else {
            return nil
        }

        return rootViewController as? UITabBarController
    }
}

/// TabBarHelper의 setTabBarVisibility 메소드를 호출하는 modifier를 만드는 구조체
struct TabBarVisibilityModifier: ViewModifier {
    let isTabBarVisible: Bool
    var tabBarHelper: TabBarHelper = .init()

    func body(content: Content) -> some View {
        content
            .onAppear {
                tabBarHelper.setTabBarVisibility(isTabBarVisible)
            }
    }
}

/// TabBarHelper의 setTabBarVisibilityByTab 메소드를 호출하는 modifier를 만드는 구조체
struct TabBarVisibilityForListViewModifier: ViewModifier {
    var tabBarHelper: TabBarHelper = .init()

    func body(content: Content) -> some View {
        content
            .onAppear {
                tabBarHelper.setTabBarVisibilityByTab()
            }
    }
}

/// SwiftUI View에서 modifier로 사용할 수 있게 extension에 추가
extension View {
    func tabBarVisibility(_ isTabBarVisible: Bool) -> some View {
        modifier(TabBarVisibilityModifier(isTabBarVisible: isTabBarVisible))
    }

    func tabBarVisibilityByTab() -> some View {
        modifier(TabBarVisibilityForListViewModifier())
    }
}
