//
//  AlertControllerWrapper.swift
//  Sodam
//
//  Created by EMILY on 25/02/2025.
//

import SwiftUI
import UIKit

/// SwiftUI View에서 UIAlertController를 사용하기 위한 객체
struct AlertControllerWrapper: UIViewControllerRepresentable {
    
    @Binding var alertPresented: Bool
    @Binding var textInput: String
    
    var alertCase: AlertCase
    var onConfirm: () -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard alertPresented else { return }
        
        let alert = UIAlertController(title: alertCase.title, message: alertCase.message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "4글자 이내로 적어주세요"
            textField.text = textInput
            textField.delegate = context.coordinator
            
            let rightLabel = UILabel()
            rightLabel.text = "담이"
            rightLabel.font = .appFont(size: .caption)
            rightLabel.textColor = .gray
            rightLabel.sizeToFit()
            
            textField.rightView = rightLabel
            textField.rightViewMode = .always
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            alertPresented = false
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                textInput = text
                onConfirm()
            }
            alertPresented = false
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        
        if uiViewController.presentedViewController == nil {
            uiViewController.present(alert, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: AlertControllerWrapper
        
        init(_ parent: AlertControllerWrapper) {
            self.parent = parent
        }
        
        /// 텍스트 필드의 실시간 입력을 감지하여 글자 수 제한을 설정하는 메서드
        func textFieldDidChangeSelection(_ textField: UITextField) {
            guard let text = textField.text else { return }
            
            if let lang = textField.textInputMode?.primaryLanguage, lang.hasPrefix("ko") {
                if text.count > 4 {
                    textField.text = String(text.prefix(4))
                }
            } else {
                if text.count > 8 {
                    textField.text = String(text.prefix(8))
                }
            }
        }
    }
}
