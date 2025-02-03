//
//  MainViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Foundation
import Combine

/// MainView의 상태와 로직을 관리하는 ViewModel.
/// HangdamRepository와 상호작용해서 데이터를 관리하고 Published 속성을 통해서 UI를 업데이트 함.
final class MainViewModel: ObservableObject {
    @Published var hangdam: HangdamDTO // 현재 관리할 행담이 데이터
    @Published var message: String = "" // 화면에 표시할 메시지
    
    // 행담이 데이터 저장 및 불러오는 레포지토리
    private let hangdamRepository: HangdamRepository
    
    init(repository: HangdamRepository) {
    /// 뷰모델 초기화 메서드
        self.hangdamRepository = repository
        self.hangdam = repository.getCurrentHangdam() // 현재 행담이 데이터를 레포지토리에서 가져옴
        self.updateMessage() // 초기화 시 메세지 업데이트
        
        // 행담이 레벨업 할때마다 특정 메시지를 보여주기 위해 observing
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessageWhenLevelUp), name: Notification.levelUP, object: nil)
    }
    
    /// 새로운 이름을 현재 행담이에 저장
    func saveNewName(as name: String) {
        hangdamRepository.nameHangdam(id: hangdam.id, name: name)
        reloadHangdam()
    }
    
    /// 행담이 이름 유무에 따라 화면 메세지를 업데이트 함
    func updateMessage() {
        if let _ = hangdam.name {
            message = MainMessages.getRandomMessage()
            print("이름이 지어졌음. 랜덤 메시지 표시")
        } else {
            message = MainMessages.firstMessage
            print("이름이 없음. 부화 메시지 표시")
        }
    }
    
    /// 레포지토리에서 현재 행담이 데이터를 다시 불러옴
    func reloadHangdam() {
        self.hangdam = hangdamRepository.getCurrentHangdam()
    }
    
    // MARK: - TodayWriteUserDefaults(테스트 하는 동안 주석처리)
    
    /// 오늘 작성했는지 확인하는 메서드
//    func hasAlreadyWrittenToday() -> Bool {
//        let lastWrittenDate = UserDefaults.standard.object(forKey: "lastWrittenDate") as? Date ?? Date.distantPast
//        let calendar = Calendar.current
//        return calendar.isDateInToday(lastWrittenDate)
//    }
//    
//    /// 오늘 작성했다고 UserDefaults에 lastWrittenDate라는 키로 저장
//    func markAsWrittenToday() {
//        let today = Calendar.current.startOfDay(for: Date())  // 시간을 00:00:00으로 초기화
//        UserDefaults.standard.set(today, forKey: "lastWrittenDate")
//        print("오늘 작성 기록 저장됨: \(today)")
//    }
    
    /// 행담이가 레벨업 할 때 메세지를 업데이트 함
    /// `levelUP` 알림(Notification)을 통해 호출됨
    @objc func updateMessageWhenLevelUp(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let level = userInfo["level"] as? Int
        else { return }
        
        // 디버깅
        print("행담이 레벨 \(level)로 성장함")
        
        // 레벨에 따른 메세지를 업데이트
        message = MainMessages.messageForLevel(level, name: hangdam.name ?? "")
    }
    
    /// deinit 시 observing 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
