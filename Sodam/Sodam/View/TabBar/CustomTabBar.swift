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
        let padding: CGFloat = UIScreen.isiPhoneSE ? 20 : 0
        newSize.height += padding
        return newSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in subviews {
            guard let tabBarButton = subview as? UIControl else { continue }
            let verticalOffset: CGFloat = UIScreen.isiPhoneSE ? 5.0 : 10.0
            let sign: CGFloat = UIScreen.isiPhoneSE ? -1 : 1
            tabBarButton.frame = tabBarButton.frame.offsetBy(dx: .zero, dy: sign * verticalOffset)
        }
    }
}
