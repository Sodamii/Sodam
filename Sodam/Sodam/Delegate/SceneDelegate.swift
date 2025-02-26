//
//  SceneDelegate.swift
//  Sodam
//
//  Created by 손겸 on 1/20/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let isFirstLaunch = !UserDefaultsManager.shared.getHasLaunchedBefor()
        
        // 메인 ViewController 설정
        if isFirstLaunch {
            // 첫 실행 시 온보딩 화면으로 시작
            let onboardingViewController = OnBoardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            onboardingViewController.onComplete = { [weak self] in
                print("[Onboarding] 완료 콜백 호출됨")
                self?.navigateToRootViewController()
            }
            window.rootViewController = onboardingViewController
        } else {
            // 첫 실행 아닐 땐 기존대로 커스텀탭바 컨트롤러로 시작
            window.rootViewController = CustomTabBarController()
        }

        window.backgroundColor = .white

        // 페이드인/페이드아웃 오버레이 설정
        let overlayView = UIView(frame: UIScreen.main.bounds)
        let imageView = UIImageView(image: UIImage(named: "LaunchImage"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = overlayView.bounds
        overlayView.addSubview(imageView)

        overlayView.alpha = 1.0 // 처음에 보이는 상태로 시작 함

        self.window = window
        window.makeKeyAndVisible()

        // 오버레이 추가
        window.addSubview(overlayView)

        // 페이드아웃 후 메인 화면 전환 + 페이드인
        UIView.animate(withDuration: 0.8, delay: 1.5, options: .curveEaseOut, animations: {
            overlayView.alpha = 0.0 // 페이드아웃
        }, completion: { _ in

            // 메인 뷰 페이드인 애니메이션
            UIView.animate(withDuration: 0.7, animations: {
                window.rootViewController?.view.alpha = 1.0 // 메인 뷰 서서히 나타남
            })

            overlayView.removeFromSuperview() // 오버레이 제거
        })
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    /**
    // 앱이 백그라운드로 전환될 때 일기 작성 여부 확인
    func sceneDidEnterBackground(_ scene: UIScene) {
        LocalNotificationManager.shared.checkDiaryAndCancelNotification()
    }
    */
    
    // MARK: - 온보딩 화면 종료 후 메인 화면 이동
    private func navigateToRootViewController() {
        let mainViewController = CustomTabBarController()
        let window = UIApplication.shared.windows.first
        UIView.transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = mainViewController
        }, completion: { _ in
            window?.makeKeyAndVisible()
        })
    }
}
