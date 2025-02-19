//
//  OnBoardingViewController.swift
//  Sodam
//
//  Created by 박민석 on 2/19/25.
//

import UIKit

final class OnBoardingViewController: UIViewController {
    
    private let onBoardingView = OnBoardingView()
    
    // 현재 페이지
    private var currentPage: Int = 0
    
    // 페이지에 들어갈 이미지와 문구
    private let infoData: [(image: UIImage?, text: String)] = [
        (UIImage(named: "page1"), "하루에 한번씩만 행복을 작성해요"),
        (UIImage(named: "page2"), "소소한 행복을 사진과 함께 기록할 수 있어요\n☝🏻 지나간 기억은 바꿀 수 없답니다"),
        (UIImage(named: "page3"), "기록한 행복 개수에 따라 성장하는\n귀여운 행담이를 만나보세요"),
        (UIImage(named: "page4"), "내가 기록한 행복을 돌아볼 수 있어요"),
        (UIImage(named: "page5"), "성장을 마친 행담이는 보관함에 들어가요\n보관된 행담이가 가진 기억도 다시 볼 수 있어요"),
        (UIImage(named: "page6"), "원하는 시간에 알림을 받아보세요\n마음에 드는 폰트를 선택할 수 있어요")
    ]
    
    override func loadView() {
        view = onBoardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAction()
        updatePage()
    }
    
    // MARK: - 버튼 탭과 제스처 액션 정의
    private func setupAction() {
        onBoardingView.setNextButtonAction(target: self, nextButtonSelector: #selector(nextButtonTapped))
        onBoardingView.setSkipButtonAction(target: self, skipButtonSelector: #selector(skipButtonTapped))
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        leftSwipeGesture.direction = .left
        onBoardingView.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        rightSwipeGesture.direction = .right
        onBoardingView.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc private func nextButtonTapped() {
        if currentPage == infoData.count - 1 {
            UserDefaultsManager.shared.saveFirstLaunchCompleted(true)
            navigateToRootViewController()
        } else {
            changePageInDirection(.left)
        }
    }
    
    @objc private func skipButtonTapped() {
        UserDefaultsManager.shared.saveFirstLaunchCompleted(true)
        navigateToRootViewController()
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        changePageInDirection(gesture.direction)
    }
    
    // 제스처 동작에 따른 현재 페이지 카운트 증감
    private func changePageInDirection(_ direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        // 왼쪽으로 이동 할 때 currentPage 감소
        case .right:
            if currentPage > 0 {
                currentPage -= 1
            }
        // 오른쪽으로 이동 할 때 currentPage 증가
        case .left:
            if currentPage < infoData.count - 1 {
                currentPage += 1
            }
        default: break
        }
        
        // currentPage에 따른 현재페이지 데이터 업데이트
        updatePage()
    }
    
    // 현재페이지 데이터 업데이트 메서드
    private func updatePage() {
        let isLastPage = currentPage == infoData.count - 1 // 마지막 페이지 여부
        let buttonTitle = isLastPage ? "시작하기" : "다음" // 마지막 페이지 여부에 따른 버튼 타이틀
        let image = infoData[currentPage].image // 해당 페이지에 들어갈 이미지
        let text = infoData[currentPage].text // 해당 페이지에 들어갈 문구
        let totalPage = infoData.count // pageControl에 전달 할 전체 페이지 수(없으면 페이지 인디케이터 안나옴)
        
        UIView.transition(
            with: onBoardingView,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let self = self else { return }
                // onBoardingView의 updatePage 호출
                self.onBoardingView.updatePage(
                    image: image,
                    text: text,
                    buttonTitle: buttonTitle,
                    isLastPage: isLastPage,
                    currentPage: self.currentPage,
                    totalPage: totalPage
                )
            },
            completion: nil)
    }
    
    // 온보딩 화면 후 메인 화면 진입
    private func navigateToRootViewController() {
        let mainViewController = CustomTabBarController()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
                                    
}
