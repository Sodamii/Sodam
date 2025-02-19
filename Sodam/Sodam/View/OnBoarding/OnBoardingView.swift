//
//  OnBoardingView.swift
//  Sodam
//
//  Created by 박민석 on 2/19/25.
//

import UIKit
import SnapKit

final class OnBoardingView: UIView {
    
//    private let leftSwipeGesture: UISwipeGestureRecognizer = {
//        let gesture = UISwipeGestureRecognizer()
//        gesture.direction = .left
//        return gesture
//    }()
//
//    private let rightSwipeGesture: UISwipeGestureRecognizer = {
//        let gesture = UISwipeGestureRecognizer()
//        gesture.direction = .right
//        return gesture
//    }()
//
//    private var currentPage: Int = 0
//    
//    private let infoData: [(image: UIImage?, text: String)] = [
//        (UIImage(named: "page1"), "하루에 한번씩만 행복을 작성해요"),
//        (UIImage(named: "page2"), "소소한 행복을 사진과 함께 기록할 수 있어요\n☝🏻 지나간 기억은 바꿀 수 없답니다"),
//        (UIImage(named: "page3"), "기록한 행복 개수에 따라 성장하는\n귀여운 행담이를 만나보세요"),
//        (UIImage(named: "page4"), "내가 기록한 행복을 돌아볼 수 있어요"),
//        (UIImage(named: "page5"), "성장을 마친 행담이는 보관함에 들어가요\n보관된 행담이가 가진 기억도 다시 볼 수 있어요"),
//        (UIImage(named: "page6"), "원하는 시간에 알림을 받아보세요\n마음에 드는 폰트를 선택할 수 있어요")
//    ]
    
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
            make.width.equalToSuperview().multipliedBy(2/3)
            make.height.equalTo(60)
        }
        
        skipButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(nextButton)
            make.height.equalTo(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}

extension OnBoardingView {
    func updatePage(
        image: UIImage?,
        text: String,
        buttonTitle: String,
        isLastPage: Bool,
        currentPage: Int
    ) {
        imageView.image = image
        infoLabel.text = text
        nextButton.setTitle(buttonTitle, for: .normal)
        skipButton.isHidden = isLastPage
        pageControl.currentPage = currentPage
        layoutIfNeeded()
    }
}
