//
//  MainViewModel.swift
//  Sodam
//
//  Created by 박진홍 on 1/26/25.
//

import Combine

final class MainViewModel: ObservableObject {
    @Published var name: String?
    @Published var message: String = "" // 화면 메시지
    @Published var gifName: String = "phase0" // gif name
    
    private let hangdamRepository: HangdamRepository
    
    init(repository: HangdamRepository = HangdamRepository()) {
        self.hangdamRepository = repository
        self.name = hangdamRepository.getCurrentHangdam().name
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
}
