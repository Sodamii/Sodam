//
//  OnBoardingView.swift
//  Sodam
//
//  Created by 박민석 on 2/19/25.
//

import UIKit
import SnapKit

final class OnBoardingView: UIView {
    
    // MARK: - UI 컴포넌트 선언
    private let imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .imageBackground
        return imageView
    }()
    
    private let infoTextView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .imageBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.25 // 그림자 투명도 25%
        view.layer.shadowRadius = 5 // 블러 효과
        view.layer.shadowOffset = .init(width: 0, height: -5) // 그림자 위치
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .appFont(size: UIScreen.isiPhoneSE ? .body1 : .subtitle)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let nextButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .buttonBackground
        button.titleLabel?.font = .appFont(size: .body1)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let skipButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.buttonBackground, for: .normal)
        button.titleLabel?.font = .appFont(size: .body2)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl: UIPageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .lightGray // 페이지 인디케이터 틴트 색상을 lightGray로 설정
        pageControl.currentPageIndicatorTintColor = .textAccent // 현재 페이지 인디케이터 틴트 색상 설정
        return pageControl
    }()
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI 레이아웃 셋업
extension OnBoardingView {
    func setupUI() {
        backgroundColor = .imageBackground
        addSubViews([imageView, infoTextView, infoLabel, nextButton, skipButton, pageControl])
        
        imageView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        infoTextView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalToSuperview().dividedBy(4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(infoTextView.snp.top).offset(12)
            make.height.equalTo(infoTextView).dividedBy(3)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(UIScreen.isiPhoneSE ? 12 : 16)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(48)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(UIScreen.isiPhoneSE ? 8 : 0)
            make.height.equalTo(12)
        }
        
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    func makeHighlightText(for text: String) -> NSMutableAttributedString {
        let highlightTexts = ["지나간 기억은 바꿀 수 없답니다", "행담이를 누르면"]
        let highlightColor = UIColor.textAccent
        let attributedText = NSMutableAttributedString(string: text)
        
        highlightTexts.forEach { highlightText in
            let range = (text as NSString).range(of: highlightText)
            if range.location != NSNotFound {
                attributedText.addAttributes([
                    .foregroundColor: highlightColor, // 색깔 표시
                    .underlineStyle: NSUnderlineStyle.single.rawValue // 밑줄 표시
                ], range: range)
            }
        }
        return attributedText
    }
}

// MARK: - 버튼 액션 설정
extension OnBoardingView {
    func setNextButtonAction(target: Any, nextButtonSelector: Selector) {
        nextButton.addTarget(target, action: nextButtonSelector, for: .touchUpInside)
    }
    func setSkipButtonAction(target: Any, skipButtonSelector: Selector) {
        skipButton.addTarget(target, action: skipButtonSelector, for: .touchUpInside)
    }
}

// MARK: - 온보딩 데이터 업데이트
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
        
        infoLabel.attributedText = makeHighlightText(for: text)
        
        layoutIfNeeded()
    }
}
