//
//  CustomTabBar.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var newSize = super.sizeThatFits(size)
        newSize.height = 90 // 높이 조절함
        return newSize
    }

}
