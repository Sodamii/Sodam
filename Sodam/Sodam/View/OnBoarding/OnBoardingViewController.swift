//
//  OnBoardingViewController.swift
//  Sodam
//
//  Created by 박민석 on 2/19/25.
//

import UIKit

final class OnBoardingViewController: UIViewController {
    
    private let onBoardingView = OnBoardingView()
    private var currentPage: Int = 0
    
    private let infoData: [(image: UIImage?, text: String)] = [
        (UIImage(named: "level0"), "하루에 한번씩만 행복을 작성해요"),
        (UIImage(named: "level1"), "소소한 행복을 사진과 함께 기록할 수 있어요\n☝🏻 지나간 기억은 바꿀 수 없답니다"),
        (UIImage(named: "level2"), "기록한 행복 개수에 따라 성장하는\n귀여운 행담이를 만나보세요"),
        (UIImage(named: "level3"), "내가 기록한 행복을 돌아볼 수 있어요"),
        (UIImage(named: "level4"), "성장을 마친 행담이는 보관함에 들어가요\n보관된 행담이가 가진 기억도 다시 볼 수 있어요"),
        (UIImage(named: "level0"), "원하는 시간에 알림을 받아보세요\n마음에 드는 폰트를 선택할 수 있어요")
    ]
    
    override func loadView() {
        view = onBoardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAction()
        updatePage()
    }
    
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
        changePageInDirection(.left)
    }
    
    @objc private func skipButtonTapped() {
        UserDefaultsManager.shared.saveFirstLaunchCompleted(true)
        navigateToRootViewController()
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        changePageInDirection(gesture.direction)
    }
    
    private func changePageInDirection(_ direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .right:
            if currentPage > 0 {
                currentPage -= 1
            }
        case .left:
            if currentPage < infoData.count - 1 {
                currentPage += 1
            }
        default: break
        }
        updatePage()
    }
    
    private func updatePage() {
        let isLastPage = currentPage == infoData.count - 1
        let buttonTitle = isLastPage ? "시작하기" : "다음"
        let image = infoData[currentPage].image
        let text = infoData[currentPage].text
        let totalPage = infoData.count
        
        onBoardingView.updatePage(
            image: image,
            text: text,
            buttonTitle: buttonTitle,
            isLastPage: isLastPage,
            currentPage: currentPage,
            totalPage: totalPage
        )
    }
    
    private func navigateToRootViewController() {
        let mainViewController = CustomTabBarController()
        let window = UIApplication.shared.windows.first
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
                                    
}
