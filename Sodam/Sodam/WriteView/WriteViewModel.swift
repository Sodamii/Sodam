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
    
    // Model의 데이터를 View에 전달
    var images: [UIImage] {
        return writeModel.post.images
    }
    var text: String {
        return writeModel.post.text
    }
    
    // 텍스트 업데이트 메서드
    func updateText(_ text: String) {
        writeModel.updateText(text)
    }
    
    // 이미지 제거
    func removeImage(at index: Int) {
        writeModel.removeImage(at: index)
    }
    
    // Model의 데이터 변경을 관찰
    func bindPostUpdated(completion: @escaping (Post) -> Void) {
        writeModel.onPostUpdated = completion
    }
    
    // 카메라 권한 요청
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
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
        @unknown default:
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
        @unknown default:
            completion(false)
        }
    }
    
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

extension WriteViewModel: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.writeModel.addImage(image)
                }
            }
        }
    }
}

extension WriteViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 찍은 이미지 가져오기
        guard let image = info[.originalImage] as? UIImage else {
            // 이미지가 유효하지 않은 경우 이미지 선택창 닫기
            picker.dismiss(animated: true)
            return
        }
        
        self.writeModel.addImage(image)
        picker.dismiss(animated: true)
    }
}
