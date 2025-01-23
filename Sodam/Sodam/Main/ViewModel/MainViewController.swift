//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    // 메인 뷰 인스턴스 생성
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMessage()    // 초기 메세지 설정
        configureButtonAction()    // 작성 버튼 액션 설정
        addGesture()               // 이미지 탭 제스처
        updateNameLabelIfNeeded()  // 앱 로드 시에 이름 라벨 업데이트
    }
    
    // 이름 라벨 업데이트
    private func updateNameLabelIfNeeded() {
        if let savedName = UserDefaults.standard.string(forKey: "HangdamName") {
            mainView.updateNameLabel(savedName) // 저장된 이름으로 라벨 업데이트
            mainView.updateGif(with: "wink") // 이름이 있으면 wink.gif 로 변경
            print("저장된 이름: \(savedName)")
        } else {
            mainView.updateGif(with: "egg") // 이름 없으면 알로 유지
            print("저장된 이름이 없습니다.")
        }
    }
    
    // 저장된 이름 여부 확인
    private func isNameSet() -> Bool {
        return UserDefaults.standard.string(forKey: "HangdamName") != nil
    }
    
    private func setupMessage() {
        if isNameSet() {
            mainView.updateMessage(MainMessages.getRandomMessage())
            print("이름이 저장된 후 앱 로드되어 랜덤 메세지를 표시")
        } else {
            mainView.updateMessage(MainMessages.firstMessage)
            print("이름이 저장되지 않은 경우 첫번째 메세지 표시")
        }
    }
    
    // 작성 버튼 클릭 시 액션 설정
    private func configureButtonAction() {
        mainView.createbutton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // 이미지 뷰 탭할 때 액션 설정
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        mainView.circularImageView.addGestureRecognizer(tapGesture)
        mainView.circularImageView.isUserInteractionEnabled = true
    }
    
    // 작성화면 모달 띄우는 메서드
    private func modalWriteViewController(with name: String) {
        let writeViewController = WriteViewController()
        writeViewController.hangdamName = name                                  // 지어진 이름 작성화면으로 전달
        writeViewController.delegate = self                                     // Delegate 연결
        writeViewController.modalTransitionStyle = .coverVertical               // 모달 스타일 설정
        present(writeViewController, animated: true)                            // 모달 표시
    }
    
    // 작성 버튼 클릭 시 호출
    @objc private func createButtonTapped() {
        if isNameSet() {
            // 이미 저장된 이름이 있는 경우에 바로 작성화면으로 이동
            if let savedName = UserDefaults.standard.string(forKey: "HangdamName") {
                print("저장된 이름으로 작성화면 이동함: \(savedName)")
                mainView.updateNameLabel(savedName)
                mainView.updateGif(with: "wink")
                modalWriteViewController(with: savedName)
            }
        } else {
            // 저장된 이름이 없는 경우 알림창 표시
            AlertManager.showAlert(on: self) { [weak self] name in
                guard let self = self else { return }
                
                if let name = name, !name.isEmpty {
                    print("입력 된 이름: \(name)")
                    
                    UserDefaults.standard.set(name, forKey: "HangdamName")       // 이름 저장
                    UserDefaults.standard.synchronize()                          // 동기화 강제
                    
                    // 이름 라벨 업데이트
                    self.mainView.updateNameLabel(name)
                    
                    // GIF 업데이트
                    self.mainView.updateGif(with: "wink")
                    
                    // 메인 화면 메세지를 랜덤 메세지로 업데이트
                    self.mainView.updateMessage(MainMessages.getRandomMessage())
                    print("이름을 지은 후 랜덤 메세지 표시 됨")
                    
                    // 작성 화면으로 이동
                    self.modalWriteViewController(with: name)
                } else {
                    print("이름이 입력되지 않았습니다.")
                }
            }
        }
    }
    
    // 이미지 탭 액션
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false             // 클릭 비활성화
        
        // 저정된 이름 유무에 따라서 메세지 업데이트
        if let savedName = UserDefaults.standard.string(forKey: "HangdamName"), !savedName.isEmpty {
            print("저장된 이름 있음: \(savedName)")
            mainView.updateMessage(MainMessages.getRandomMessage())             // 이름 있으면 메세지 표시
        } else {
            print("저장된 이름 없음. 첫번째 메세지 유지")
            mainView.updateMessage(MainMessages.firstMessage)                   // 이름 없으면 첫번째 메세지 유지
        }
        
        // 2초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true     // 클릭 재활성화
        }
    }
}

// 작성화면 모달이 닫힐 때 처리
extension MainViewController: WriteViewControllerDelegate {
    func writeViewControllerDiddismiss() {
        print("WriteViewController 모달이 닫혔습니다.")
    }
}
