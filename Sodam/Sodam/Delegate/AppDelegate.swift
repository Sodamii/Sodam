//
//  AppDelegate.swift
//  Sodam
//
//  Created by 손겸 on 1/20/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let center = UNUserNotificationCenter.current() // 알림센터 가져오기
        center.delegate = self //앱 실행 시 사용자에게 알림 허용 권한을 받음
        
        // 권한 요청 메서드(꼭 이곳이 아니어도 원할때 권한을 받을 수 있다.)
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정

        center.requestAuthorization(options: authOptions) { success, error in
            // 권한에 따라 success가 허용->true, 거부->error
            if let error = error {
                print("에러 발생: \(error.localizedDescription)")
            }
        }
        
        // 예약 알림 설정


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// MARK: - UNUserNotificationCenterDelegate Setting Method

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground 상태인 경우(앱 실행중인상태) 알림이 오면 해당 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound, .list])
    }
    
    // 사용자가 알림을 탭했을때 해당 메서드 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()  // 응답 처리가 완료되었음을 시스템에 알림
    }
}
