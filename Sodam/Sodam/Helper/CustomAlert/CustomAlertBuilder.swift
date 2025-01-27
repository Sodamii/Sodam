//
//  CustomAlert.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import UIKit

final class CustomAlertBuilder {
    private var config: AlertConfiguration = AlertConfiguration()
    
    func setTitle(to title: String) -> Self {
        self.config.title = title
        return self
    }
    
    func setMessage(to message: String) -> Self {
        self.config.message = message
        return self
    }
    
    func setTextFieldPlaceHolder(to placeHolder: String) -> Self {
        self.config.textFieldPlaceHolder = placeHolder
        return self
    }
    
    func addAction(title: String, style: AlertActionStyle, handler: @escaping (String?) -> Void) -> Self {
        self.config.actions.append((title: title, style: style, handler: handler))
        return self
    }
    
    func setBackground(color: UIColor, cornerRadius: CGFloat = 15) -> Self {
        self.config.backgroundColor = color
        self.config.cornerRadius = cornerRadius
        return self
    }
    
    func setAlertFont(font: UIFont) -> Self {
        self.config.alertFont = font
        return self
    }
    
    func setTitleColor(to color: UIColor) -> Self {
        self.config.titleColor = color
        return self
    }
    
    func setMessageFontColor(to color: UIColor) -> Self {
        self.config.messageColor = color
        return self
    }
    
    func build() -> CustomAlertViewController {
        return CustomAlertViewController(config: config)
    }
}

