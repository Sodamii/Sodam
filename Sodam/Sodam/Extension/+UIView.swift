//
//  +UIView.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit
import SnapKit

extension UIView {
    func addSubViews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension UIView {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        
        // 토스트 표시할 Label 생성
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = .mapoGoldenPier(16)
        label.text = message // 표시 할 메세지 설정
        label.alpha = 0.0 // 초기 투명도 (완전 투명)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        
        // 토스트 뷰에 추가
        self.addSubview(label)
        
        // 제약 조건
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(170)
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalTo(35)
        }
        
        // 애니메이션으로 토스트 메시지 표시
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            label.alpha = 1.0 // 0.5초 동안 투명도 1.0으로 변경되면서 서서히 나타남
        }, completion: { _ in
            
            // 토스트 메세지가 일정 시간동안 표시된 후 사라지는 애니메이션
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                label.alpha = 0.0 // 0.5초 동안 투명도를 0.0으로 서서히 사라짐
            }, completion: { _ in
                label.removeFromSuperview() // 애니메이션 끝나면 Label을 뷰에서 제거함
            })
        })
    }
}
