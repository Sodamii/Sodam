//
//  MainView.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    private let circularImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .tabBackground
        imageView.backgroundColor = .imageBackground
        
        // 원형 스타일
        imageView.layer.cornerRadius = 150
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let createbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("행복 작성하기", for: .normal)
        button.setTitleColor(.imageBackground, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.MapoGoldenPier.rawValue, size: 20)
        button.backgroundColor = .buttonBackground
        button.layer.cornerRadius = 15
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .viewBackground
        [
            circularImageView,
            createbutton
        ].forEach { addSubview($0) }
        
        circularImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height * 0.15) // 화면 높이의 30%로 높이를 맞춤
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        createbutton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
            $0.width.equalToSuperview().multipliedBy(0.85)
        }
    }
}
