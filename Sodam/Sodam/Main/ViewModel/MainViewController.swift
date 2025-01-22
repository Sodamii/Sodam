//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    private var isCreateButtonFirstTap = true // 처음 클릭 여부
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstMessage()
        addGesture()
        configureButtonAction()
        
    }
    
    private func configureFirstMessage() {
        // 앱 초기 실행 시 첫번째 문구 설정
        mainView.updateMessage(MainMessages.firstMessage)
    }
    
    // 작성 버튼 액션 설정
    private func configureButtonAction() {
        mainView.createbutton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // 이미지 뷰 제스처 추가 설정
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        mainView.circularImageView.addGestureRecognizer(tapGesture)
        mainView.circularImageView.isUserInteractionEnabled = true
    }
    
    // 작성 모달 띄우는 메서드
    private func modalWriteViewController(with name: String) {
        let writeViewController = WriteViewController()
        
        // 지어진 이름 작성화면으로 전달
        writeViewController.hangdamName = name
        
        // 모달 스타일
        writeViewController.modalTransitionStyle = .coverVertical
        
        // 모달 표시
        present(writeViewController, animated: true)
    }
    
    // 이미지 탭 액션
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false // 클릭 비활성화
        
        mainView.updateMessage(MainMessages.getRandomMessage())
        
        // 2초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true // 클릭 재활성화
        }
    }
    
    // 버튼 탭 액션
    @objc private func createButtonTapped() {
        if isCreateButtonFirstTap {
            AlertManager.showAlert(on: self) { [weak self] name in
                guard self != nil else { return }
                
                if let name = name, !name.isEmpty {
                    print("지어진 이름: \(name)")
                    self?.isCreateButtonFirstTap = false // 이름을 입력해야 업데이트
                    self?.modalWriteViewController(with: name)
                } else {
                    print("이름이 입력되지 않았습니다.")
                }
            }
        } else {
            print("이미 이름을 지었습니다")
        }
    }
}
