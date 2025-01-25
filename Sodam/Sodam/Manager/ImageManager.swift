//
//  ImageManager.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import UIKit

final class ImageManager {
    
    // 이미지 리사이징 목표 크기
    private let resizeFloat: CGFloat = 450
    
    // 현재 시간 timestamp를 String으로 반환하는 함수
    func nameImagePath() -> String {
        /// split.first 접근에 실패할 경우 uuid 값으로라도 고유한 값 생성하도록 처리
        guard let imagePath = String(Date.now.timeIntervalSince1970).split(separator: ".").first
        else {
            return UUID().uuidString
        }
        
        return String(imagePath)
    }
    
    // 이미지 저장
    func saveImage(_ image: UIImage, with imagePath: String) {
        /// 1.  이미지 리사이징
        let resizedImage = resizeImage(image)
        
        /// 2. FileManager로 기기에 저장
        saveImageAsFile(image: resizedImage, imagePath: imagePath)
    }
}

// 내부 호출 함수 모음
extension ImageManager {
    /// 이미지 리사이징하는 함수
    private func resizeImage(_ image: UIImage) -> UIImage {
        /// 이미지 고유 비율
        let aspectRatio = image.size.width / image.size.height
        
        var newSize: CGSize
        
        /// 가로 사진이면 가로가 목표 크기, 세로 사진이면 세로가 목표 크기가 되게 리사이징
        if image.size.width > image.size.height {
            newSize = CGSize(width: resizeFloat, height: resizeFloat / aspectRatio)
        } else {
            newSize = CGSize(width: resizeFloat * aspectRatio, height: resizeFloat)
        }
        
        /// newSize에 맞게 이미지 렌더링
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        let resizedImage = renderer.image(actions: { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        })
        
        return resizedImage
    }
    
    /// 이미지를 FileManager를 통해 기기에 저장하는 함수
    private func saveImageAsFile(image: UIImage, imagePath: String) {
        /// 이미지 퀄리티 원본의 80%, 확장자 jpeg인 Data로 변환
        guard let data = image.jpegData(compressionQuality: 0.8),
              let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        let fileURL = directory.appendingPathComponent("\(imagePath).jpeg")
        
        do {
            try data.write(to: fileURL)
            print("[FileManager] 이미지 저장 성공")
        } catch let error {
            print(FileError.imageSaveFailed.localizedDescription)
            print(error.localizedDescription)
        }
    }
}
