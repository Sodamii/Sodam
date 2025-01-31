//
//  AlertManager.swift
//  Sodam
//
//  Created by 손겸 on 1/22/25.
//

import UIKit

final class AlertManager {
    
    // 금지어 포함 여부 확인
    private static func containsForbiddenWord(_ text: String) -> Bool {
        for word in ForbiddenWords.list {
            if text.contains(word) {
                return true
            }
        }
        return false
    }
    
    // 이름 입력 알림창
    static func showAlert(
        on viewController: UIViewController,
        completion: @escaping (String?) -> Void
    ) {
        let alartController = UIAlertController(
            title: "이름 짓기",
            message: "4글자 이내로 지어주세요",
            preferredStyle: .alert
        )
        
        // 알럿 안에 텍스트 필드
        alartController.addTextField { textField in
            textField.placeholder = "이름을 입력하세요"
            // 텍스트 필드 델리게이트
            textField.delegate = viewController as? UITextFieldDelegate
            
            // 텍스트필드 옆에 Label추가
            let rightLabel = UILabel()
            rightLabel.text = "담이"
            rightLabel.font = .mapoGoldenPier(14)
            rightLabel.textColor = .gray
            rightLabel.sizeToFit()
            
            // Label을 rightView로 설정
            textField.rightView = rightLabel
            textField.rightViewMode = .always
        }
        
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            guard let name = alartController.textFields?.first?.text else {
                viewController.view.showToast(message: "이름을 입력해주세요.")
                return
            }
            
            // 글자 수 확인
            if name.count > 6 {
                viewController.view.showToast(message: "이름은 6글자가 초과되었습니다.")
                return
            }
            
            // 금지어 확인
            if containsForbiddenWord(name) {
                viewController.view.showToast(message: "적절하지 않은 이름입니다.")
                return
            }
            completion(name) // 입력된 이름 전달
        }
        confirmAction.setValue(UIColor.buttonBackground, forKey: "titleTextColor")
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.setValue(UIColor.lightGray, forKey: "titleTextColor")
        
        // 버튼 추가
        alartController.addAction(confirmAction)
        alartController.addAction(cancelAction)
        
        // 알림창 표시
        viewController.present(alartController, animated: true)
    }
}
