//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let mainView = MainView()
    
    // 처음 클릭 여부 확인
    private var isFirstTap = true
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstMessage()
        addGesture()
        
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print(" - \(fontName)")
            }
        }
    }
    
    private func configureFirstMessage() {
        // 앱 초기 실행 시 첫번째 문구 설정
        mainView.updateMessage(MainMessages.firstMessage)
    }
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        mainView.circularImageView.addGestureRecognizer(tapGesture)
        mainView.circularImageView.isUserInteractionEnabled = true
    }
    
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false // 클릭 비활성화
        
        if isFirstTap {
            isFirstTap = false // 첫번째 클릭 이후 상태 변경
        }
        mainView.updateMessage(MainMessages.getRandomMessage())
        
        // 2초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true // 클릭 재활성화
        }
    }
}
