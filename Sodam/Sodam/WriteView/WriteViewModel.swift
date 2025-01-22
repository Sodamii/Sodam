//
//  WriteViewModel.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import PhotosUI
import AVFoundation

// 카메라 접근, 사진 선택 로직 처리
final class WriteViewModel: NSObject {
    
    private let writeModel: WriteModel
    
    struct Input {
        let textUpdated: ((String) -> Void)
        let cameraAccessRequested: (() -> Void)
        let imagePickerRequested: (() -> Void)
    }
    
    struct Output {
        var postUpdated: ((Post) -> Void)
        var cameraAccessGranted: ((Bool) -> Void)
        var showImagePicker: ((PHPickerViewController) -> Void)
        var imagesUpdated: (() -> Void)
    }
    
    var input: Input
    var output: Output
    
    // 데이터 변경 알림용 클로저
    var onImagesUpdated: (() -> Void)?
    var images: [UIImage] {
        return writeModel.post.images
    }
    
    init(writeModel: WriteModel) {
        self.writeModel = writeModel
        
        // 기본값을 설정
        self.input = Input(
            textUpdated: { _ in },
            cameraAccessRequested: { },
            imagePickerRequested: { }
        )
        self.output = Output(
            postUpdated: { _ in },
            cameraAccessGranted: { _ in },
            showImagePicker: { _ in },
            imagesUpdated: { }
        )
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        // Model에서 Post가 업데이트되면 View로 전달
        writeModel.onPostUpdated = { [weak self] post in
            self?.output.postUpdated(post)
        }
        
        // Input/Output 연결
        self.input = Input(
            textUpdated: { [weak self] text in
                self?.writeModel.updateText(text)
            },
            cameraAccessRequested: { [weak self] in
                self?.requestCameraAccess()
            },
            imagePickerRequested: { [weak self] in
                self?.showImagePicker()
            }
        )
        
//        self.output = Output(
//            postUpdated: { _ in },
//            cameraAccessGranted: { _ in },
//            showImagePicker: { _ in }
//        )
    }
    
    // 카메라 권한 요청
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
            DispatchQueue.main.async {
                self.output.cameraAccessGranted(isAuthorized)
            }
        }
    }
    
    func showImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 한 번에 하나의 이미지 선택
        configuration.filter = .images // 이미지 형식만 허용
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        output.showImagePicker(picker)
    }
    
    // 이미지 제거
    func removeImage(at index: Int) {
        writeModel.removeImage(at: index)
        output.imagesUpdated()
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
                    self?.output.imagesUpdated()
                }
            }
        }
    }
}

extension WriteViewModel: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 찍은 이미지 가져오기
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            // 이미지가 유효하지 않은 경우 이미지 선택창 닫기
            picker.dismiss(animated: true)
            return
        }
        
        self.writeModel.addImage(image)
        picker.dismiss(animated: true)
    }
}
