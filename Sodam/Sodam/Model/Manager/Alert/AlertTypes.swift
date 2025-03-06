//
//  AlertTypes.swift
//  Sodam
//
//  Created by 손겸 on 2/14/25.
//

import UIKit

// MARK: - 알럿 타입 정의

enum AlertMessage {
    case emptyText
    case imageLimit
    case alreadyWrittenToday
    case writeCompleted
    case cameraPermission
    case imagePermission
    case textLimit
    case biometryAvailable
    case biometryNotAvailable
    case biometryNotEnrolled
    case authenticationFailed
    case biometryLockout
    case userCancel
    case systemCancel
    case unknownBiometryError
    
    var title: String {
        switch self {
        case .emptyText:
            return "행복 기록이 없습니다"
        case .imageLimit:
            return "이미지를 추가할 수 없습니다."
        case .alreadyWrittenToday:
            return "오늘의 소확행 작성 완료!"
        case .writeCompleted:
            return "작성 완료"
        case .cameraPermission:
            return "현재 카메라 사용에 대한 접근 권한이 없습니다."
        case .imagePermission:
            return "현재 사진 라이브러리 접근에 대한 권한이 없습니다."
        case .textLimit:
            return "글자 수 제한 초과"
        case .biometryAvailable:
            return "생체 인증 성공"
        case .biometryNotAvailable:
            return "생체 인증을 사용할 수 없음"
        case .biometryNotEnrolled:
            return "생체 인증이 설정되지 않음"
        case .authenticationFailed:
            return "생체 인증 실패"
        case .biometryLockout:
            return "생체 인증이 잠김"
        case .userCancel:
            return "인증이 취소됨"
        case .systemCancel:
            return "시스템에 의해 인증이 취소됨"
        case .unknownBiometryError:
            return "알 수 없는 오류"
        }
    }

    var message: String {
        switch self {
        case .emptyText:
            return "내용을 입력해주세요!"
        case .imageLimit:
            return "하나의 글에 최대 한 개의 이미지만 \n 추가할 수 있습니다."
        case .alreadyWrittenToday:
            return "내일 또 당신의 소소한 행복을 작성해주세요"
        case .writeCompleted:
            return "글이 성공적으로 작성되었습니다!"
        case .cameraPermission, .imagePermission:
            return "설정 > Sodam 탭에서 접근 권한을 활성화 해주세요."
        case .textLimit:
            return "최대 입력 글자는 500자 입니다."
        case .biometryAvailable:
            return "앱 잠금이 활성화 되었습니다."
        case .biometryNotAvailable:
            return "이 기기에서는 생체 인증을 사용할 수 없습니다."
        case .biometryNotEnrolled:
            return "생체 인증을 사용하려면 설정에서 권한을 허용해주세요."
        case .authenticationFailed:
            return "인증에 실패했습니다. 다시 시도해주세요."
        case .biometryLockout:
            return "생체 인증을 여러 번 실패하여 생체 인증이 잠겼습니다."
        case .userCancel:
            return "인증을 취소했습니다."
        case .systemCancel:
            return "다른 앱 사용 또는 시스템에 의해 인증이 취소되었습니다."
        case .unknownBiometryError:
            return "알 수 없는 오류로 생체 인증에 실패했습니다."
        }
    }
}

// MARK: - 토스트 메시지 정의

enum ToastMessage {
    case invalidName
    case nameTooLong
    case nameRequired

    var message: String {
        switch self {
        case .invalidName:
            return "적절하지 않은 이름입니다."
        case .nameTooLong:
            return "최대 4글자까지만 입력 가능합니다."
        case .nameRequired:
            return "이름을 입력해주세요."
        }
    }
}

// MARK: - 버튼 탭 타입 (카메라 / 사진 라이브러리 접근 권한)
enum ButtonTapType {
    case camera        // 카메라 접근 권한이 없을 때
    case image         // 사진 라이브러리 접근 권한이 없을 때
}
