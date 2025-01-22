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
    
    // 작성 버튼을 처음 눌렀는지 판단 (UserDefaults에 저장된 이름이 없으면 true)
    private var isCreateButtonFirstTap: Bool {
        return UserDefaults.standard.string(forKey: "HangdamName") == nil
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstMessage()  // 초기 메세지 설정
        addGesture()             // 이미지 탭 제스처
        configureButtonAction()  // 작성 버튼 액션 설정
    }
    
    private func configureFirstMessage() {
        // 앱 초기 실행 시 첫번째 문구 설정
        mainView.updateMessage(MainMessages.firstMessage)
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
        writeViewController.hangdamName = name                                 // 지어진 이름 작성화면으로 전달
        writeViewController.delegate = self                                    // Delegate 연결
        writeViewController.modalTransitionStyle = .coverVertical              // 모달 스타일 설정
        present(writeViewController, animated: true)                           // 모달 표시
    }
    
    // 이미지 탭 액션
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false             // 클릭 비활성화
        
        // 랜덤 메세지 업데이트
        mainView.updateMessage(MainMessages.getRandomMessage())
        
        // 2초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true     // 클릭 재활성화
        }
    }
    
    // 작성 버튼 클릭 시 호출
    @objc private func createButtonTapped() {
        if isCreateButtonFirstTap {
            // 이름이 없는 경우 알림창 표시하기
            AlertManager.showAlert(on: self) { [weak self] name in
                guard self != nil else { return }
                
                if let name = name, !name.isEmpty {
                    print("지어진 이름: \(name)")
                    UserDefaults.standard.set(name, forKey: "HangdamName")       // 이름 저장
                    self?.modalWriteViewController(with: name)                   // 작성화면으로 이동
                } else {
                    print("이름이 입력되지 않았습니다.")
                }
            }
        } else {
            // 이미 저장된 이름이 있는 경우에 바로 작성화면으로 이동
            if let savedName = UserDefaults.standard.string(forKey: "HangdamName") {
                print("저장된 이름으로 작성화면 이동함: \(savedName)")
                modalWriteViewController(with: savedName)
            }
        }
    }
}

// 작성화면 모달이 닫힐 때 처리
extension MainViewController: WriteViewControllerDelegate {
    func writeViewControllerDiddismiss() {
        print("모달이 닫혔습니다.")
    }
}
