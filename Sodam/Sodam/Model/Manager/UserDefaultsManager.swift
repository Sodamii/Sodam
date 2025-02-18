//
//  UserDefaultsManager.swift
//  Sodam
//
//  Created by 박시연 on 1/22/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let userDefaults = UserDefaults.standard

    private init() {}

    // 이름 충돌 방지 및 재사용성 증가
    private enum Keys {
        // MARK: - 작성 뷰
        
        static let content = "content"  // 작성 내용
        static let imagePath = "imagePath"  // 작성시 등록 이미지

        // MARK: - 설정 뷰

        static let notificationTime = "time"  // 앱 알림 시간
        static let appSettingToggleState = "appSettingToggleState"  // 앱 설정 토글 상태
        static let notificationAuthorizationStatus = "notificationAuthorizationStatus"  // 알림 권한 상태 (허용/거부)를 UserDefaults에 저장
        static let diaryWrittenTime = "diaryWrittenTime"  // 기록 작성 시간 확인
        static let notificationInitialSetupComplete = "notificationInitialSetupComplete" // 앱 알림 초기 설정 여부 확인
        static let isDiaryWritten = "isDiaryWritten"  // 기록 작성 여부 확인
    }

    // MARK: - 작성 뷰 Save

    // 작성된 내용(content)을 UserDefaults에 저장
    func saveContent(_ content: String) {
        userDefaults.set(content, forKey: Keys.content)
    }

    // 작성된 이미지 경로(imagePath)를 UserDefaults에 저장
    func saveImagePath(_ imagePath: [String]) {
        userDefaults.set(imagePath, forKey: Keys.imagePath)
    }

    // MARK: - Local Notification Save
    
    // 알림 시간을 UserDefaults에 저장
    func saveNotificationTime(_ time: Date) {
        userDefaults.set(time, forKey: Keys.notificationTime)
    }

    // 앱 설정 알림 토글 상태 (ON/OFF)를 UserDefaults에 저장
    func saveAppToggleState(_ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: Keys.appSettingToggleState)
    }
    
    // 알림 권한 상태 (허용/거부)를 UserDefaults에 저장
    func saveNotificaionAuthorizationStatus(_ isAuthorized: Bool) {
        userDefaults.set(isAuthorized, forKey: Keys.notificationAuthorizationStatus)
    }

    // 일기 작성 여부 저장(알림시간 전 작성된 내용이 있는 경우 확인)
    func saveDiaryWrittenStatus() {
        UserDefaults.standard.object(forKey: Keys.isDiaryWritten)
    }

    // 알림 초기 설정 완료 여부를 확인 (알림 설정이 처음 완료되었는지 여부)
    func isNotificationSetupComplete() -> Bool {
        return userDefaults.bool(forKey: Keys.notificationInitialSetupComplete)
    }

    // MARK: - 작성 뷰 Get

    // 작성된 내용을 가져옴
    func getContent() -> String? {
        userDefaults.string(forKey: Keys.content)
    }

    // 저장된 이미지 경로 목록을 가져옴
    func getImagePath() -> [String]? {
        userDefaults.stringArray(forKey: Keys.imagePath)
    }

    // 임시 저장된 콘텐츠와 이미지 경로 삭제
    func deleteTemporaryPost() {
        print("[WriteView] 임시저장 됐던 content와 imagePath 삭제")
        userDefaults.removeObject(forKey: Keys.content)
        userDefaults.removeObject(forKey: Keys.imagePath)
    }

    // MARK: - Local Notification Get

    // 알림 초기 설정을 완료 표시 (true가 완료, false가 미완료)
    func markNotificationSetupAsComplete() {
        userDefaults.set(true, forKey: Keys.notificationInitialSetupComplete)
    }

    // 앱 설정 알림 토글 상태 (ON/OFF)를 가져옴
    func getAppToggleState() -> Bool {
        userDefaults.bool(forKey: Keys.appSettingToggleState)
    }

    // 저장된 알림 권한 상태를 가져옴
    func getNotificaionAuthorizationStatus() -> Bool {
        return userDefaults.bool(forKey: Keys.notificationAuthorizationStatus)
    }

    // 저장된 알림 시간을 가져옴
    func getNotificationTime() -> Date? {
        userDefaults.object(forKey: Keys.notificationTime) as? Date
    }

    // 저장된 일기 작성 시간을 가져옴
    func getDiaryWrittenTime() -> Date? {
        return userDefaults.object(forKey: Keys.diaryWrittenTime) as? Date
    }

    // 일기 작성 여부 불러오기
    func getDiaryWrittenStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isDiaryWritten)
    }

    // 일기 작성 시간을 저장
    func markDiaryAsWritten() {
        let currentDate = Date()
        UserDefaults.standard.set(currentDate, forKey: Keys.diaryWrittenTime)
        UserDefaults.standard.set(true, forKey: Keys.isDiaryWritten)
    }

    /// 오늘 작성했다고 UserDefaults에 기록
    func markAsWrittenToday() {
        let today = Calendar.current.startOfDay(for: Date())  // 시간을 00:00:00으로 초기화
        UserDefaults.standard.set(today, forKey: "isDiaryWritten")  // UserDefaults에 오늘 날짜 기록
        print("오늘 작성 기록 저장됨: \(today)")
        
        // 일기 작성 상태와 시간을 UserDefaults에 저장
        UserDefaultsManager.shared.markDiaryAsWritten()
    }
}
