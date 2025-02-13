//
//  ImageCollectionViewCell.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    // 휴지통 버튼
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .red
        button.layer.cornerRadius = 8
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "trash")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10) // 이미지 크기 설정
        button.configuration = config
        return button
    }()
    
    // 블러 효과를 위한 뷰
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight) // 블러 스타일
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 4
        blurView.clipsToBounds = true
        return blurView
    }()
    
    // 삭제 버튼 액션을 위한 클로저
    var onDelete: (() -> Void)?
    
    // 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(blurView)
        contentView.addSubview(deleteButton)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.edges.equalTo(blurView) // 블러 뷰와 동일한 크기로 설정
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 이미지 설정
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    @objc private func deleteButtonTapped() {
        onDelete?()
    }
}
