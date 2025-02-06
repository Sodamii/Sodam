//
//  ImageManager.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import UIKit

final class ImageManager {
    /// 현재 시간 timestamp를 String으로 반환하는 함수
    func nameImagePath() -> String {
        /// split.first 접근에 실패할 경우 uuid 값으로라도 고유한 값 생성하도록 처리
        guard let imagePath = String(Date.now.timeIntervalSince1970).split(separator: ".").first
        else {
            return UUID().uuidString
        }
        
        return String(imagePath)
    }
    
    /// 이미지를 저장하는 함수 : 리사이징 목표치 기본값 450
    func saveImage(_ image: UIImage, with imagePath: String, size: CGFloat = 450) {
        /// 1.  이미지 리사이징
        let resizedImage = resizeImage(image, resizeFloat: size)
        
        /// 2. FileManager로 기기에 저장
        saveImageAsFile(image: resizedImage, imagePath: imagePath)
    }
    
    /// 이미지 불러오는 함수
    func getImage(with imagePath: String) -> UIImage? {
        let result = loadImageFile(imagePath: imagePath)
        
        switch result {
        case .success(let image):
            return image
        case .failure(let error):
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// 썸네일 이미지 만드는 함수 : 리사이징 목표치 기본값 150
    func getThumbnailImage(with imagePath: String, size: CGFloat = 150) -> UIImage? {
        guard let image = getImage(with: imagePath) else {
            return nil
        }
        
        /// 이미지 크기
        let width = image.size.width
        let height = image.size.height
        
        let scale = size / min(width, height)
        
        /// 이미지 비율 유지한 채 150 크기로 줄임
        let newWidth = width * scale
        let newHeight = height * scale
        
        /// 가운데 부분을 crop 하기 위해 긴 부분만큼 이동시킬 offset 계산
        let xOffset = (newWidth - size) / -2.0
        let yOffset = (newHeight - size) / -2.0
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        
        let thumbnail = renderer.image { _ in
            image.draw(in: CGRect(x: xOffset, y: yOffset, width: newWidth, height: newHeight))
        }
        
        return thumbnail
    }
    
    /// 이미지 삭제하는 함수
    func deleteImage(_ imagePath: String) {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "\(imagePath).jpeg") else {
            print(FileError.imageSearchFailed)
            return
        }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("[ImageManager] 이미지 삭제 완료")
        } catch {
            print(FileError.imageDeleteFailed)
        }
    }
 }

// 내부 호출 함수 모음
extension ImageManager {
    /// 이미지 리사이징하는 함수
    private func resizeImage(_ image: UIImage, resizeFloat: CGFloat) -> UIImage {
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
        
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
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
    
    /// FileManager를 통해 이미지를 불러오는 함수
    private func loadImageFile(imagePath: String) -> Result<UIImage?, FileError> {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "\(imagePath).jpeg"),
              let data = FileManager.default.contents(atPath: url.path())
        else {
            return .failure(FileError.imageFetchFailed)
        }
        
        return .success(UIImage(data: data))
    }
}
