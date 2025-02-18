//
//  ToastManager.swift
//  Sodam
//
//  Created by 박시연 on 2/10/25.
//

import UIKit

final class ToastManager {
    // 싱글턴 인스턴스
    static let shared = ToastManager()

    private init() {} // 외부에서 인스턴스를 생성할 수 없도록 init은 private

    // 특정 뷰에서 토스트 표시
    func showToastMessage(message: String, duration: TimeInterval = 2.0) {
        let scenes = UIApplication.shared.connectedScenes
        guard let windowScene = scenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        // 토스트 표시할 Label 생성
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = .mapoGoldenPier(16)
        label.text = message // 표시할 메세지 설정
        label.alpha = 0.0 // 초기 투명도 (완전 투명)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping // 줄 바꿈

        // 내부 패딩을 위해 UIView 감싸기
        let toastContainer = UIView()
        toastContainer.alpha = 0.0
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        toastContainer.layer.cornerRadius = 10
        toastContainer.clipsToBounds = true

        // 토스트 뷰에 추가
        window.addSubview(toastContainer)
        toastContainer.addSubview(label)

        // 레이아웃 수정
        toastContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(window.snp.bottom).inset(window.bounds.height * 0.25) // 화면 하단에서 일정 거리 떨어짐
            $0.leading.greaterThanOrEqualTo(toastContainer.snp.leading).inset(12)
            $0.trailing.lessThanOrEqualTo(toastContainer.snp.trailing).inset(12)
        }

        // label이 자동으로 늘어나도록 설정
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10) // 내부 여백 추가
            $0.leading.trailing.equalToSuperview().inset(12) // 좌우 여백 추가
        }

        // 애니메이션으로 토스트 메시지 표시
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            label.alpha = 1.0 // 0.5초 동안 투명도 1.0으로 변경되면서 서서히 나타남
            toastContainer.alpha = 1.0
        }, completion: { _ in

            // 토스트 메세지가 일정 시간동안 표시된 후 사라지는 애니메이션
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                label.alpha = 0.0 // 0.5초 동안 투명도를 0.0으로 서서히 사라짐
                toastContainer.alpha = 0.0
            }, completion: { _ in
                label.removeFromSuperview() // 애니메이션 끝나면 Label을 뷰에서 제거함
            })
        })
    }
}
