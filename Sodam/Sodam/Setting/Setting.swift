//
//  Enum.swift
//  Sodam
//
//  Created by t2023-m0019 on 1/21/25.
//

import Foundation

enum Setting {
    // 설정 Section
    enum SetSection: String {
        case appSetting = "앱 설정"
        case develop = "환경 설정"
    }
    
    // 설정 Cell
    enum SetCell: String {
        case notification = "알림 설정"  // 알림 스위치
        case setTime = "시간"
        case appReview = "앱 리뷰 남기기" // 앱 리뷰 남기러 가기
        case appVersion = "앱 버전"     // 앱 버전
    }
}
