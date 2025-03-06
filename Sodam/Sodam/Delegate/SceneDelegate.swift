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
        window.backgroundColor = .white
        self.window = window
        
        let biometricAuthManger: BiometricAuthManager = BiometricAuthManager()
        let isFirstLaunch = !UserDefaultsManager.shared.getHasLaunchedBefor()
        let useBiometrics = UserDefaultsManager.shared.getUseBiometric()
        
        let launchViewController = UIViewController()
        window.rootViewController = launchViewController
        window.makeKeyAndVisible()
        
        let targetViewController: UIViewController
        
        // 생체 인증을 사용하지 않는 경우 바로 메인 화면 or 온보딩 화면으로 이동
        // 첫 실행 시 온보딩 화면 아닌 경우 메인 화면
        if isFirstLaunch {
            biometricAuthManger.setupBiometryType() // touch id인지 face id인지 확인 후 저장
            
            let onboardingViewController = OnBoardingViewController()
            onboardingViewController.modalPresentationStyle = .fullScreen
            onboardingViewController.onComplete = { [weak self] in
                self?.navigateToRootViewController(rootViewController: CustomTabBarController())
            }
            targetViewController = onboardingViewController
        } else {
            if useBiometrics {
                // 사용자가 생체 인증을 활성화한 경우 LockViewController 띄우기
                let lockViewController = LockViewController(biometricAuthManager: biometricAuthManger)
                lockViewController.onAuthenticationSuccess = { [weak self] in
                    self?.navigateToRootViewController(rootViewController: CustomTabBarController())
                }
                targetViewController = lockViewController
            } else {
                targetViewController = CustomTabBarController()
            }
        }
        
        // 페이드인/페이드아웃 오버레이 설정
        let overlayView = UIView(frame: UIScreen.main.bounds)
        let imageView = UIImageView(image: UIImage(named: "LaunchImage"))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = overlayView.bounds
        overlayView.addSubview(imageView)
        
        overlayView.alpha = 1.0 // 처음에 보이는 상태로 시작 함
        window.addSubview(overlayView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                overlayView.alpha = 0.0 // 페이드아웃
            }, completion: { _ in
                // 메인 뷰 페이드인 애니메이션
                UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = targetViewController
                    window.rootViewController?.view.alpha = 1.0 // 메인 뷰 서서히 나타남
                }, completion: nil)
                
                overlayView.removeFromSuperview() // 오버레이 제거
            })
        }
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
    private func navigateToRootViewController(rootViewController: UIViewController) {
        guard let window = self.window else { return }

        UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: {
            window.rootViewController = rootViewController
        }, completion: { _ in
            window.makeKeyAndVisible()
        })
    }
}
