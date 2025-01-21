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
        imageView.tintColor = .systemYellow
        imageView.backgroundColor = .whiteColor
        
        // 원형 스타일
        imageView.layer.cornerRadius = 150
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let createbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("행복 작성하기", for: .normal)
        button.setTitleColor(.whiteColor, for: .normal)
        button.titleLabel?.font = UIFont(name: CustomFont.MapoGoldenPier.rawValue, size: 20)
        button.backgroundColor = .happyColor
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
        backgroundColor = .backgroundColor
        [
            circularImageView,
            createbutton
        ].forEach { addSubview($0) }
        
        circularImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(130)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300)
        }
        
        createbutton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
            $0.top.equalTo(circularImageView.snp.bottom).offset(170)
        }
    }
}
