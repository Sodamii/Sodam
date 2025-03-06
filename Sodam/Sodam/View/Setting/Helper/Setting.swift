//
//  Setting.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit

enum Setting {
    // 설정 Section
    enum SetSection: String {
        case appSetting = "앱 설정"
        case develop = "환경 설정"
        case fontSetting = "폰트 설정"
        case lockSetting = "앱 잠금 설정"
    }

    // 설정 Cell
    enum SetCell: String {
        case notification = "알림 설정"  // 알림 스위치
        case setTime = "시간"
        case fontSetting = "폰트 설정"
        case biometricAuth = "앱 잠금"
        case appReview = "앱 리뷰 남기기" // 앱 리뷰 남기러 가기
        case appVersion = "앱 버전"     // 앱 버전
        case feedback = "버그제보 / 문의" // 사용자 피드백
    }
}
