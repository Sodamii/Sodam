//
//  +UIView.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
