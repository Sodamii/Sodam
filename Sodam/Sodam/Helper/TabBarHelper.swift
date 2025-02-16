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
    func setTabBarVisitility(_ isVisible: Bool) {
        withAnimation {
            if let tabBarController = getRootTabBarController() {
                tabBarController.tabBar.isHidden = !isVisible
            }
        }
    }
    
    private func getRootTabBarController() -> UITabBarController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let rootViewController = sceneDelegate.window?.rootViewController else {
            return nil
        }
        
        return rootViewController as? UITabBarController
    }
}

struct TabBarVisibilityModifier: ViewModifier {
    let isTabBarVisible: Bool
    var tabBarHelper: TabBarHelper = .init()
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                tabBarHelper.setTabBarVisitility(isTabBarVisible)
            }
    }
}

extension View {
    func tabBarVisibility(_ isTabBarVisible: Bool) -> some View {
        modifier(TabBarVisibilityModifier(isTabBarVisible: isTabBarVisible))
    }
}
