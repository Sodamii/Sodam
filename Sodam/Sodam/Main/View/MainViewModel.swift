//
//  MainViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    @Published var name: String?
    @Published var message: String = "" // 화면 메시지
    @Published var gifName: String = "phase0" // gif name
    
    private let hangdamRepository: HangdamRepository
    
    init(repository: HangdamRepository = HangdamRepository()) {
        self.hangdamRepository = repository
        let currentHangdam = hangdamRepository.getCurrentHangdam()
        self.name = currentHangdam.name
        self.gifName = "phase\(currentHangdam.level)" // 현재 레벨에 맞는 GIF 설정
        self.updateMessage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMessageWhenLevelUp), name: Notification.levelUP, object: nil)
    }
    
    func setGif() {
        self.name = hangdamRepository.getCurrentHangdam().name
        if name != nil {
            gifName = "phase\(hangdamRepository.getCurrentHangdam().level)"
        } // TODO: 이름이 없는 경우 레벨이 0으로 고정이라면 if let 자체가 필요없을 듯
    }
    
    func saveNewName(as name: String ) {
        let currentHangdamID: String = hangdamRepository.getCurrentHangdam().id
        hangdamRepository.nameHangdam(id: currentHangdamID, name: name)
        setGif()
    }
    
    func updateMessage(force: Bool = false) {
        if !force { // 강제 업데이트가 아닌 경우 기존 메시지가 비어 있는지 확인
            guard message.isEmpty else {
                print("updateMessage: 이미 메시지가 설정되어 있음. 덮어쓰지 않음.")
                return
            }
        }
        
        if let _ = name {
            message = MainMessages.getRandomMessage()
            print("이름이 지어졌음. 랜덤 메시지 표시")
        } else {
            message = MainMessages.firstMessage
            print("이름이 없음. 부화 메시지 표시")
        }
    }
    
    func getCurrentHangdamID() -> String {
        return hangdamRepository.getCurrentHangdam().id
    }
    
    @objc func updateMessageWhenLevelUp(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let level = userInfo["level"] as? Int,
              let currentName = name
        else {
            print("updateMessageWhenLevelUp: Notification 정보 누락")
            return
        }
        message = MainMessages.getLevelUpMessage(level: level, name: currentName)
        gifName = "phase\(level)"
        
        // 디버깅
        print("행담이 레벨 \(level)로 성장함. 메시지 업데이트: \(message)")
    }
    
    /// deinit 시 observing 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
