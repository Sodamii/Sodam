//
//  ImagePickerServiceProtocol.swift
//  Sodam
//
//  Created by 박민석 on 2/13/25.
//

import UIKit

/// 이미지 선택 완료 시 호출되는 메서드를 정의
protocol ImagePickerServiceDelegate: NSObject {
    func didFinishPicking(_ image: UIImage?)
}

/// 이미지 피커 서비스의 기본 메서드를 정의
protocol ImagePickerServicable {
    func setDelegate(_ self: ImagePickerServiceDelegate)
    func requestAccess(_ viewController: UIViewController, completion: @escaping (Bool) -> Void)
    func show(_ viewController: UIViewController)
}
