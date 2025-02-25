//
//  AlertCase.swift
//  Sodam
//
//  Created by 손겸 on 2/14/25.
//

import UIKit

// MARK: - 알럿 타입 정의

enum AlertCase {
    case emptyText
    case imageLimit
    case alreadyWrittenToday
    case writeCompleted
    case cameraPermission
    case imagePermission
    case notificationPermission
    case textLimit
    case nameHangdam
    case renameHangdam
    case deleteHappiness

    var title: String {
        switch self {
        case .emptyText:
            return "행복 기록이 없습니다"
        case .imageLimit:
            return "이미지를 추가할 수 없습니다."
        case .alreadyWrittenToday:
            return "오늘의 소확행 작성 완료!"
        case .writeCompleted:
            return "행복 작성 완료"
        case .cameraPermission:
            return "현재 카메라 사용에 대한 접근 권한이 없습니다."
        case .imagePermission:
            return "현재 사진 라이브러리 접근에 대한 권한이 없습니다."
        case .notificationPermission:
            return "앱의 알림을 받으려면 알림 권한 허용이 필요합니다."
        case .textLimit:
            return "글자 수 제한 초과"
        case .nameHangdam:
            return "이름 지어주기"
        case .renameHangdam:
            return "행담이 이름 바꾸기"
        case .deleteHappiness:
            return "정말 삭제하시겠습니까?"
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
        case .cameraPermission:
            return "설정 > 카메라에서 접근 권한을 활성화 해주세요."
        case .imagePermission:
            return "설정 > 사진 탭에서 사진 보관함 접근을 변경해주세요."
            case .notificationPermission:
            return "설정 > 알림에서 알림 허용을 켜주세요."
        case .textLimit:
            return "최대 입력 글자는 500자 입니다."
        case .nameHangdam:
            return "행담이에게 이름을 지어주세요."
        case .renameHangdam:
            return "새로 지어줄 이름을 입력해주세요."
        case .deleteHappiness:
            return "삭제한 행복은 되돌릴 수 없습니다."
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
