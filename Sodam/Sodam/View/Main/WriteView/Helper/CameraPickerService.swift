//
//  CameraPickerService.swift
//  Sodam
//
//  Created by t2023-m0072 on 2/13/25.
//

import UIKit
import AVFoundation

/// 카메라 이미지 피커 서비스 구현
final class CameraPickerService: NSObject, ImagePickerServicable {
    weak var delegate: ImagePickerServiceDelegate?
    
    // UIImagePickerController 초기화 (카메라 사용 설정)
    private let imagePickerController: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .camera
        return picker
    }()
    
    // 초기화 메서드에서 delegate 설정
    override init() {
        super.init()
        imagePickerController.delegate = self
    }
    
    // 카메라 접근 권한 요청
    func requestAccess(_ viewController: UIViewController, completion: @escaping (Bool) -> Void ) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { isGranted in
                DispatchQueue.main.async {
                    completion(isGranted)
                }
            }
        case .denied, .restricted:
            completion(false)
        default:
            completion(false)
        }
    }
    
    /// 카메라 촬영 화면 표시
    func show(_ viewController: UIViewController) {
        viewController.present(imagePickerController, animated: true)
    }
    
    /// 카메라 델리게이트 설정
    func setDelegate(_ self: ImagePickerServiceDelegate) {
        delegate = self
    }
}

// MARK: - UIImagePickerController 델리게이트 구현 (카메라 촬영 후 처리)
extension CameraPickerService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 사용자가 촬영을 마쳤을 때 호출되는 메서드
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 사용자가 촬영한 이미지 가져오기
            guard let image = info[.originalImage] as? UIImage else {
                print("[CameraPickerService] 이미지 선택 실패: \(info)")
                delegate?.didFinishPicking(nil)
                picker.dismiss(animated: true)
                return
            }
            
            // 선택된 이미지 전달
            delegate?.didFinishPicking(image)
            
            // 이미지 선택 후 피커 닫기
            picker.dismiss(animated: true)
    }
}
