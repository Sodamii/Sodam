//
//  PhotoLibraryPickerService.swift
//  Sodam
//
//  Created by t2023-m0072 on 2/13/25.
//

import PhotosUI

final class PhotoLibraryPickerService: ImagePickerServicable {
    weak var delegate: ImagePickerServiceDelegate?

    // PHPickerViewController 초기화 (사진 라이브러리 설정)
    private let imagePickerController: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 한 번에 선택할 수 있는 사진 개수 제한
        configuration.filter = .images // 이미지 파일만 선택 가능
        let imagePickerController = PHPickerViewController(configuration: configuration)
        return imagePickerController
    }()

    // 초기화 시 델리게이트 설정
    init() {
        imagePickerController.delegate = self
    }

    /// 사진 라이브러리 접근 권한 요청
    func requestAccess(_ viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        case .denied, .restricted:
            completion(false)
        default:
            completion(false)
        }
    }

    /// 사진 라이브러리 화면 표시
    func show(_ viewController: UIViewController) {
        viewController.present(imagePickerController, animated: true)
    }

    /// 이미지 선택기 델리게이트 설정
    func setDelegate(_ self: ImagePickerServiceDelegate) {
        delegate = self
    }
}

// MARK: - PHPickerViewController 델리게이트 구현 (사진 선택 후 처리)
extension PhotoLibraryPickerService: PHPickerViewControllerDelegate {
    /// 사용자가 이미지를 선택하면 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 이미지 선택 후 피커를 닫기
        picker.dismiss(animated: true)

        // 선택된 이미지의 provider 가져오기
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            // 이미지가 없거나 로드할 수 없는 경우 nil 반환
            print("[PhotoLibraryPickerService] 이미지가 없거나 로드할 수 없음")
            delegate?.didFinishPicking(nil)
            return
        }

        // 이미지 로드 시도
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let error = error {
                print("[PhotoLibraryPickerService] 이미지 로드 실패: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.delegate?.didFinishPicking(nil)
                }
                return
            }

            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    // 이미지가 성공적으로 로드된 경우 delegate를 통해 전달
                    self?.delegate?.didFinishPicking(image)
                }
            } else {
                print("[PhotoLibraryPickerService] 이미지 변환 실패")
                DispatchQueue.main.async {
                    self?.delegate?.didFinishPicking(nil)
                }
            }
        }
    }
}
