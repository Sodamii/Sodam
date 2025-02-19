//
//  OnBoardingView.swift
//  Sodam
//
//  Created by 박민석 on 2/19/25.
//

import UIKit
import SnapKit

final class OnBoardingView: UIView {
    
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let infoTextView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .imageBackground
        view.layer.shadowColor = UIColor.systemBackground.cgColor
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 5
        view.layer.shadowOffset = .init(width: 0, height: -2)
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .mapoGoldenPier(20)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let nextButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .buttonBackground
        button.titleLabel?.font = .mapoGoldenPier(18)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let skipButton: UIButton = {
        let button: UIButton = UIButton()
        let title = "건너뛰기"
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.mapoGoldenPier(16),
            .foregroundColor: UIColor.buttonBackground
        ]
        let attributedString = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray // 페이지 인디케이터 틴트 색상을 lightGray로 설정
        pageControl.currentPageIndicatorTintColor = .buttonBackground // 현재 페이지 인디케이터 틴트 색상 설정
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnBoardingView {
    func setupUI() {
        backgroundColor = .buttonBackground
        addSubViews([imageView, infoTextView, infoLabel, nextButton, skipButton, pageControl])
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide)
        }
        
        infoTextView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(infoTextView.snp.top).inset(10)
            make.height.equalTo(50)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.height.equalTo(12)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(48)
        }
        
        skipButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nextButton)
            make.height.equalTo(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}

extension OnBoardingView {
    func setNextButtonAction(target: Any, nextButtonSelector: Selector) {
        nextButton.addTarget(target, action: nextButtonSelector, for: .touchUpInside)
    }
    func setSkipButtonAction(target: Any, skipButtonSelector: Selector) {
        skipButton.addTarget(target, action: skipButtonSelector, for: .touchUpInside)
    }
}

extension OnBoardingView {
    func updatePage(
        image: UIImage?,
        text: String,
        buttonTitle: String,
        isLastPage: Bool,
        currentPage: Int,
        totalPage: Int
    ) {
        imageView.image = image
        infoLabel.text = text
        nextButton.setTitle(buttonTitle, for: .normal)
        skipButton.isHidden = isLastPage
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = totalPage
        
        layoutIfNeeded()
    }
}
