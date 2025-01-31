//
//  LocalNotificationManager.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import UserNotifications
import UIKit

final class LocalNotificationManager {
    static let shared = LocalNotificationManager()
    
    private init() {}
    
    /// 특정 시점에 알람 설정(매일, 사용자가 선택한 시간)
    /// - Parameters:
    ///   - time: 사용자가 설정한 알림 시간
    func setReservedNotification(_ time: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Sodam"  // Push Notification에 표시할 제목
        content.body = "소소한 행복을 적어 행담이를 키워주세요."  // Push Notification에 표시할 본문
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1) // 기존 뱃지 숫자에서 1씩 증가
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true) // ✅ 매일 설정한 시간에 울리게 설정
        
        // identifier: 실행 취소, 알림 구분 등에 사용되는 식별자
        let request = UNNotificationRequest(identifier: "SelectedTimeNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ 알림 등록 실패: \(error.localizedDescription)")
            } else {
                print("✅ 알림 등록 성공! 예약 시간: \(components.hour ?? 0):\(components.minute ?? 0)")
            }
        }
    }
}
