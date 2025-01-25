//
//  ImageManager.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import UIKit

final class ImageManager {
    
    /// 이미지 리사이징 목표 크기
    private let resizeFloat: CGFloat = 450
    
    /// 현재 시간 timestamp를 String으로 반환하는 함수 - 내부 호출
    private func nameImagePath() -> String {
        /// split.first 접근에 실패할 경우 uuid 값으로라도 고유한 값 생성하도록 처리
        guard let imagePath = String(Date.now.timeIntervalSince1970).split(separator: ".").first
        else {
            return UUID().uuidString
        }
        
        return String(imagePath)
    }
    
    /// 이미지 크기를 450으로 리사이징하는 함수 - 내부 호출
    private func resizeImage(_ image: UIImage) -> UIImage {
        /// 이미지 고유 비율
        let aspectRatio = image.size.width / image.size.height
        
        var newSize: CGSize
        
        /// 가로 사진이면 가로가 450, 세로 사진이면 세로가 450이 되게 리사이징
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

    func saveImage(_ image: UIImage) {
        
    }
    
    private func resizeImage(_ image: UIImage) -> UIImage? {
        return nil
    }
}
