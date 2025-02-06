//
//  CustomAlertConfiguration.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import UIKit

enum AlertActionStyle {
    case onlyYes
    case canCancle
}

struct AlertConfiguration {
    var title: String?
    var message: String?
    var textFieldPlaceHolder: String?
    var actions: [(title: String, style: AlertActionStyle, handler: (String?) -> Void)] = []
    var backgroundColor: UIColor = .cellBackground
    var cornerRadius: CGFloat = 15.0
    var alertFont: UIFont = .mapoGoldenPier(16)
    var titleColor: UIColor = .textAccent
    var messageColor: UIColor = .darkGray
}
