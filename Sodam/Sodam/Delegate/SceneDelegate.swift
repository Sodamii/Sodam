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

        // 메인 ViewController 설정
        if isFirstLaunch() {
            // 첫 실행 시 온보딩 화면으로 시작
            window.rootViewController = OnBoardingViewController()
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
    
    // 첫 실행인지 확인하는 메서드
    private func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaultsManager.shared.getHasLaunchedBefor()
        if isFirstLaunch {
            // 첫 실행이면 UserDefaults에 true 저장
            UserDefaultsManager.shared.saveFirstLaunchCompleted(true)
        }
        // 첫 실행 여부 반환
        return isFirstLaunch
    }
}
