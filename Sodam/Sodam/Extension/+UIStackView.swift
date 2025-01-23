//
//  +UIStackView.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubViews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
