//
//  LocalNotificationManager.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import Foundation
import UserNotifications

final class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    private init() {}
    
    /// 특정 시점에 알람 설정(사용자가 선택한 날짜)
    /// - Parameters:
    ///   - title: Push Notification에 표시할 제목
    ///   - body: Push Notification에 표시할 본문
    ///   - time: 사용자가 설정한 알림 시간
    ///   - seconds: 현재로부터 seconds초 이후에 알림을 보냅니다. 0보다 커야하며 1이하 실수도 가능
    ///   - identifier: 실행 취소, 알림 구분 등에 사용되는 식별자입니다. "TEST_NOTI" 형식으로 작성
    func pushReservedNotification(title: String,
                                  body: String,
                                  time: Date,
                                  seconds: Double,
                                  identifier: String) {
        
        // 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        // 알림이 발송될 정확한 시간 설정
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: time)
        // 사용자가 지정한 `time`을 기반으로 알림 트리거를 설정
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)

        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
