//
//  CustomTabBar.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        
        // 기기 화면 높이에 따라 탭바 높이 계산하기
        let screenHeight = UIScreen.main.bounds.height
        newSize.height = screenHeight * 0.11 // 화면 높이의 11%로 고정
        return newSize
    }

}
