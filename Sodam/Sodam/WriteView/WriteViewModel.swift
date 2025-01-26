//
//  WriteViewModel.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit
import PhotosUI
import AVFoundation

// 카메라 접근, 사진 선택 로직 처리
final class WriteViewModel: NSObject {
    
    private let writeModel: WriteModel
    
    
    init(writeModel: WriteModel) {
        self.writeModel = writeModel
        super.init()
    }
    
    // MARK: - 데이터 접근 메서드
    
    // Model의 이미지 데이터를 View에 전달
    var images: [UIImage] {
        return writeModel.post.images
    }
    // Model의 텍스트 데이터를 View에 전달
    var text: String {
        return writeModel.post.content
    }
    
    // MARK: - 데이터 업데이트 메서드
    
    // 텍스트 업데이트 메서드
    func updateText(_ text: String) {
        writeModel.updateText(text)
    }
    
    // 이미지 제거 메서드
    func removeImage(at index: Int) {
        writeModel.removeImage(at: index)
    }
    
    // 작성 완료 이벤트 처리
    func submitPost() {
        
    }
    
    // 작성 취소 이벤트 처리
    func cancelPost() {
        
    }
    
    // MARK: - 데이터 변경 관찰
    
    // Model의 데이터 변경을 관찰
    func bindPostUpdated(completion: @escaping (Post) -> Void) {
        writeModel.onPostUpdated = completion
    }
    
    // MARK: - 권한 요청 메서드
    
    // 카메라 권한 요청
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized: // 권한이 이미 허용된 경우
            completion(true)
        case .notDetermined:  // 권한이 아직 결정되지 않은 경우
            AVCaptureDevice.requestAccess(for: .video) { isGranted in // 접근 권한 요청
                DispatchQueue.main.async {
                    completion(isGranted) // 허용 여부 외부로 전달
                }
            }
        case .denied, .restricted: // 권한이 거부되었거나 제한된 경우
            completion(false)
        default:  // 알 수 없는 경우
            completion(false)
        }
    }
    
    // 사진 라이브러리 권한 요청
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
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
    
    // MARK: - 컨트롤러 생성 메서드
    
    // 카메라 컨트롤러 생성
    func createCameraPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        return picker
    }
    
    // 사진 선택 컨트롤러 생성
    func createPhotoPicker() -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        return picker
    }
}

// MARK: - PHPickerViewController(이미지 선택할 때 사용) 설정

extension WriteViewModel: PHPickerViewControllerDelegate {
    // 사진 선택이 완료되었을 때 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // 피커 닫기
        defer {
            picker.dismiss(animated: true)
        }
        
        // 선택된 결과가 없거나 이미지를 로드할 수 없는 경우 종료
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        // 이미지 로드
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    // 이미지 추가
                    self?.writeModel.addImage(image)
                }
            }
        }
    }
}

// MARK: - ImagePickerController(카메라 동작할 때 사용) 설정

extension WriteViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // 카메라로 찍은 이미지 선택이 완료되었을 때 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 찍은 이미지 가져오기
        guard let image = info[.originalImage] as? UIImage else {
            // 이미지가 유효하지 않은 경우 이미지 선택창 닫기
            picker.dismiss(animated: true)
            return
        }
        // 이미지 추가
        self.writeModel.addImage(image)
        // 피커 닫기
        picker.dismiss(animated: true)
    }
}
