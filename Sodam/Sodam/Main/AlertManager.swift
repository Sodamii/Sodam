//
//  AlertManager.swift
//  Sodam
//
//  Created by 손겸 on 1/22/25.
//

import UIKit

final class AlertManager {
    
    // 이름 입력 알림창
    static func showAlert(
        on viewController: UIViewController,
        completion: @escaping (String?) -> Void
    ) {
        let alartController = UIAlertController(
            title: "행담이의 이름을 지어주세요.",
            message: nil,
            preferredStyle: .alert
        )
        
        // 알럿 안에 텍스트 필드
        alartController.addTextField { TextField in
            TextField.placeholder = "행담이 이름"
        }
        
        // 확인 버튼
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            let name = alartController.textFields?.first?.text
            completion(name) // 입력된 이름 전달
        }
        confirmAction.setValue(UIColor.buttonBackground, forKey: "titleTextColor")
        
        // 취소 버튼
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        // 버튼 추가
        alartController.addAction(confirmAction)
        alartController.addAction(cancelAction)
        
        // 알림창 표시
        viewController.present(alartController, animated: true)
    }
}
