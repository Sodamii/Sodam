//
//  LockViewController.swift
//  Sodam
//
//  Created by 박민석 on 3/6/25.
//

import UIKit

final class LockViewController: UIViewController {
    
    private let biometricAuthManager: BiometricAuthManager
    private lazy var alertManager = AlertManager(viewController: self)
    
    var onAuthenticationSuccess: (() -> Void)? // 인증 완료 후 실행할 클로저
    private let biometryTypeString: String = UserDefaultsManager.shared.getBiometricType() ?? "Face ID 또는 Touch ID"
    
    init(biometricAuthManager: BiometricAuthManager) {
        self.biometricAuthManager = biometricAuthManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("LockViewController view did load")
        // 권한 확인 후 요청
        let granted = biometricAuthManager.isBiometricAvailable()
        if granted {
            authenticateUser()
        } else {
            alertManager.showBiometricPermissionAlert()
        }
    }

    private func authenticateUser() {
        print("[LockViewController] \(biometryTypeString) 인증 실행")
        let reason = "앱을 잠금을 해제하려면 \(biometryTypeString) 인증이 필요합니다."
        biometricAuthManager.authenticateUser(reason: reason) { [weak self] success, errorCode in
            guard let self = self else { return }
            if success {
                self.onAuthenticationSuccess?()
            } else {
                guard let errorCode = errorCode else {
                    print("[LockViewController] 알 수 없는 에러로 앱 잠금 설정 실패")
                    self.alertManager.showAlert(alertMessage: .unknownBiometryError)
                    return
                }
                
                // 실패 이유에 따른 분기 처리
                switch errorCode {
                case .biometryNotEnrolled, .biometryNotAvailable:
                    print("[LockViewController] 잠금 해제 실패 - 생체 인증이 등록되어 있지 않거나 권한이 거부됨")
                    self.alertManager.showBiometricPermissionAlert()
                case .biometryLockout:
                    print("[LockViewController] 잠금 해제 실패 - 여러번 실패하여 생체 인증 기능이 잠김")
                    showAuthenticationFailedAlert()
                case .userCancel:
                    print("[LockViewController] 잠금 해제 실패 - 사용자가 인증을 취소함")
                    showAuthenticationFailedAlert()
                case .systemCancel:
                    print("[LockViewController] 잠금 해제 실패 - 시스템에 의해 인증이 취소됨")
                    showAuthenticationFailedAlert()
                default:
                    print("[LockViewController] 잠금 해제 실패 - 기타 오류 발생")
                    self.alertManager.showAlert(alertMessage: .unknownBiometryError)
                }
            }
        }
    }
    
    private func showAuthenticationFailedAlert() {
        print("[LockViewController] \(biometryTypeString)인증 및 암호 인증 실패 Alert 호출")
        alertManager.showRetryBiometricAlert { [weak self] in
            guard let self = self else { return }
            self.authenticateUser()
        }
    }
}
