//
//  WriteViewModel.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import PhotosUI

// 카메라 접근, 사진 선택 로직 처리
final class WriteViewModel: NSObject, PHPickerViewControllerDelegate {
    
    
    private let writeModel: WriteModel
    
    struct Input {
        let textUpdated: ((String) -> Void)?
        let cameraAccessReequested: ((Bool) -> Void)?
        let addImageTapped: ((UIViewController) -> Void)?
    }
    
    struct Output {
        var postUpdated: ((Post) -> Void)?
    }
    
    var input: Input
    var output: Output
    private var post: Post {
        didSet {
            output.postUpdated?(post)
        }
    }
    
    init(
        writeModel: WriteModel,
        post: Post = Post(text: "", image: nil)
    ) {
        self.writeModel = writeModel
        self.post = post
        self.input = Input(textUpdated: nil, cameraAccessReequested: nil, addImageTapped: nil)
        self.output = Output(postUpdated: nil)
    }
    
    func updateText(_ text: String) {
        post.text = text
    }
    
    func updateImage(_ image: UIImage) {
        post.image = image
    }

    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        writeModel.requestCameraAccess { isAuthorized in
            completion(isAuthorized)
        }
    }
    
    func addImage(from viewController: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1 // 한 번에 하나의 이미지 선택
        configuration.filter = .images // 이미지 형식만 허용
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let image = image as? UIImage {
                DispatchQueue.main.async {
                    self?.updateImage(image)
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
    
}
