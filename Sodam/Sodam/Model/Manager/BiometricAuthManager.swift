//
//  BiometricAuthManager.swift
//  Sodam
//
//  Created by 박민석 on 3/6/25.
//

import Foundation
import LocalAuthentication

final class BiometricAuthManager {

    private var biometryTypeString: String = "Face ID 또는 Touch ID" // 기본값
    
    /// 현재 기기가 Face ID인지, Touch ID인지 확인 후 저장
    func setupBiometryType() {
        print("[BiometricAuthManager] 생체 인증 타입 \(biometryTypeString)으로 저장됨")
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            switch context.biometryType {
            case .faceID:
                biometryTypeString = "Face ID"
            case .touchID:
                biometryTypeString = "Touch ID"
            default:
                biometryTypeString = "Face ID 또는 Touch ID"
            }
            UserDefaultsManager.shared.saveBiometricsType(biometryTypeString)
        }
    }
    
    /// 생체 인증 사용 가능 여부 확인
    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    /// 인증 실행 (생체 인증 + 암호 인증)
    func authenticateUser(reason: String, completion: @escaping (Bool, LAError.Code?) -> Void) {
        let context = LAContext()
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("[BiometricAuthManager] 인증 성공")
                    completion(true, nil)
                } else {
                    if let laError = error as? LAError {
                        switch laError.code {
                        case .biometryNotAvailable:
                            print("[BiometricAuthManager] 기기가 생체 인증을 지원하지 않음")
                        case .biometryNotEnrolled:
                            print("[BiometricAuthManager] 사용자가 생체 인증을 등록하지 않음")
                        case .biometryLockout:
                            print("[BiometricAuthManager] 생체 인증이 여러 번 실패하여 잠김")
                        case .authenticationFailed:
                            print("[BiometricAuthManager] 생체 인증 시도 실패")
                        case .userCancel:
                            print("[BiometricAuthManager] 사용자가 인증 취소")
                        case .userFallback:
                            print("[BiometricAuthManager] 사용자가 암호 입력 선택")
                        case .systemCancel:
                            print("[BiometricAuthManager] 다른 앱이 활성화되어 인증이 취소됨")
                        case .passcodeNotSet:
                            print("[BiometricAuthManager] 기기에 암호(PIN)가 설정되지 않음")
                        default:
                            print("[BiometricAuthManager] 기타 오류 발생: \(laError.localizedDescription)")
                        }
                        completion(false, laError.code)
                    } else {
                        print("[BiometricAuthManager] 알 수 없는 오류 발생")
                        completion(false, nil)
                    }
                }
            }
        }
    }
}
