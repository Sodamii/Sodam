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
    
    init(repository: HangdamRepository) {
        self.hangdamRepository = repository
        self.name = hangdamRepository.getCurrentHangdam().name
        self.updateMessage() // 초기화 시 메세지 업데이트
        
        // 행담이 레벨업 할때마다 특정 메시지를 보여주기 위해 observing
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
    
    func updateMessage() {
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
              let level = userInfo["level"] as? Int
        else { return }
        
        /// 디버깅
        print("행담이 레벨 \(level)로 성장함")
        
        // TODO: 레벨에 따라 다른 메시지 설정
        // MARK: 레벨에 따라 gif 설정하는 것도 여기서 하면 좋을 듯 (setGif 구현 여기로 옮기기)
    }
    
    /// deinit 시 observing 해제
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
