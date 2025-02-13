//
//  AlertManager.swift
//  Sodam
//
//  Created by 손겸 on 1/22/25.
//

import UIKit

// MARK: - 알럿 타입 정의
enum ButtonTapType {
    case camera        // 카메라 접근 권한이 없을 때
    case image         // 사진 라이브러리 접근 권한이 없을 때
}

final class AlertManager {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    /// 일반적인 알럿 표시
    /// - Parameters:
    ///   - title: 알럿의 제목
    ///   - message: 알럿의 메세지
    ///   - actions: 알럿에 추가할 액션들
    func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        // 알럿 컨트롤러 (제목, 메세지, 스타일 설정)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 전달된 액션이 없으면 기본 "확인" 버튼을 추가함
        if actions.isEmpty {
            alertController.addAction(UIAlertAction(title: "확인", style: .default))
        } else {
            // 전달된 액션들을 알럿에 추가
            actions.forEach { alertController.addAction($0) }
        }
        
        // 화면에 알럿 표시
        viewController?.present(alertController, animated: true)
    }
    
    // MARK: - mainViewController 알럿
    
    /// 이름 입력 알럿 표시
    /// - Parameter completion: 사용자가 입력한 이름을 반환하는 클로저
    func showNameInputAlert(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: "이름 지어주기",
            message: "한 번 정한 이름은 바꿀 수 없으니 \n 신중하게 지어주세요!",
            preferredStyle: .alert
        )
        
        alertController.addTextField { [weak self] textField in
            textField.placeholder = "4글자 이내로 적어주세요"
            textField.addTarget(self, action: #selector(self?.textFieldDidChange(_:)), for: .editingChanged)
            
            let rightLabel = UILabel()
            rightLabel.text = "담이"
            rightLabel.font = .mapoGoldenPier(14)
            rightLabel.textColor = .gray
            rightLabel.sizeToFit()
            
            textField.rightView = rightLabel
            textField.rightViewMode = .always
        }
        
        // 확인 버튼 액션 설정
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            //입력된 이름이 비어있는지 확인
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else {
                // 이름 비어있으면 토스트 메세지로 알림
                ToastManager.shared.showToastMessage(message: "이름을 입력해주세요.")
                return
            }
            
            // 이름 길이 네글자 초과하는지 확인
            if name.count > 4 {
                // 글자수 초과하면 토스트 메세지로 알림
                ToastManager.shared.showToastMessage(message: "최대 글자수를 초과했습니다.")
                return
            }
            
            // 금지어가 포함된 이름인지 확인
            if AlertManager.containsForbiddenWord(name) {
                // 금지어 있으면 토스트 메세지로 아림
                ToastManager.shared.showToastMessage(message: "적절하지 않은 이름입니다.")
                return
            }
            
            // 유효한 이름이 입력되면 '담이'를 추가해서 최종 이름 생성
            let finalName = "\(name)담이"
            completion(finalName)
        }
        
        // 취소 버튼 액선 설정
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        // 알럿에 확인 버튼과 취소 버튼 추가
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true)
    }
    
    /// 이미 작성했다면 나오는 알럿
    func showAlreadyWrittenTodayAlert() {
        showAlert(
            title: "오늘의 소확행 작성 완료!",
            message: "내일 또 당신의 소소한 행복을 작성해주세요"
        )
    }
    
    // MARK: - WriteViewController 알럿
    
    /// 행복 작성이 빈 공간일 경우
    func showEmptyTextAlert() {
        showAlert(
            title: "행복 기록이 없습니다",
            message: "내용을 입력해주세요!"
        )
    }
    
    /// 이미지 개수 제한 경고 알럿
    func showImageLimitAlert() {
        showAlert(
            title: "이미지를 추가할 수 없습니다.",
            message: "하나의 글에 최대 한 개의 이미지만 \n 추가할 수 있습니다."
        )
    }
    
    /// 작성 완료 알럿
    func showCompletionAlert(dismissHandler: @escaping () -> Void) {
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            dismissHandler()
        }
        showAlert(title: "작성 완료", message: "글이 성공적으로 작성되었습니다!", actions: [okAction])
    }
    
    /// 설정 이동 알럿 (카메라 / 사진 라이브러리)
    /// - Parameter type: 카메라 또는 이미지 접근 권한에 대한 설정 이동 여부
    func showGoToSettingsAlert(for type: ButtonTapType) {
        let title: String
        switch type {
        case .camera:
            title = "현재 카메라 사용에 대한 접근 권한이 없습니다."
        case .image:
            title = "현재 사진 라이브러리 접근에 대한 권한이 없습니다."
        }
        
        let settingsAction = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingsURL) else {
                return
            }
            UIApplication.shared.open(settingsURL)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        showAlert(title: title, message: "설정 > Sodam 탭에서 접근 권한을 활성화 해주세요.", actions: [cancelAction, settingsAction])
    }
    
    // MARK: - 실시간 입력 감지
    
    /// 텍스트 필드의 실시간 입력을 감지하여 글자 수 제한을 설정하는 메서드
    @objc private func textFieldDidChange(_ textField: UITextField) {
        DispatchQueue.main.async {
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
    
    // MARK: - 금지어
    
    /// 금지어 목록을 확인하여, 텍스트에 포함된 금지어가 있는지 체크하는 메서드
    private static func containsForbiddenWord(_ text: String) -> Bool {
        // contains로 금지어들 중에 포함되면 true를 반환 시킴
        return ForbiddenWords.list.contains { text.contains($0) }
    }
}
