//
//  ImageManagerActor.swift
//  Sodam
//
//  Created by 박진홍 on 2/20/25.
//

import UIKit

actor ImageRepository {
    private let cacher: GenericCacher<UIImage>
    
    init(cacher: GenericCacher<UIImage> = GenericCacher<UIImage>()) {
        self.cacher = cacher
    }
    /// 오늘 날짜를 String으로 반환 시도 및 실패 시 UUID의 문자열을 반환
    ///
    /// `slpit`은 `[SubString]`을 반환하므로 `split().first`의 타입은
    /// `SubString?`이 됨. 따라서 `String`으로 변환해주고 `nil`일 경우엔
    /// `UUID().uuidString`으로 반환함
    func createImagePath() async -> String {
        return String(Date.now.timeIntervalSince1970)
            .split(separator: ".")
            .first
            .map(String.init) ?? UUID().uuidString
        
    }
    
    /// 이미지를 백그라운드에서 저장하는 작업
    ///
    /// `actor`에는 순차적으로 작업이 수행되기 때문에 이미지 렌더링과 저장에 시간이 소요될 경우
    /// 다른 요청들이 밀릴 가능성이 있음. 따라서 `Task.detached`를 통해 현재 `actor`와 별개의 `Task`에서
    /// 작업을 진행하여 `actor`의 다른 작업이 원활히 진행되게 함.
    func saveImage(_ image: UIImage, to path: String, size: CGFloat = 450) async throws {
        try await Task.detached(priority: .userInitiated) { [weak self] () throws -> Void in
            guard let self = self else { throw DataError.selfIsNil}
            let resizedImage = await self.resizeImage(image, to: size)
            try await self.saveImageAsFile(resizedImage, to: path)
        }.value
    }
    
    func getImage(from path: String?) async throws -> UIImage {
        guard let path: String = path else { throw FileError.invalidPath}
        return try loadImageFile(from: path)
    }
    
    func getThumbnailImage(from path: String?) async throws -> UIImage {
        try await cacher.getValueByKey(path) { [weak self] () throws -> UIImage in
            guard let self = self else { throw FileError.selfIsNil}
            let image: UIImage = try await self.getImage(from: path)
            return await self.resizeImage(image, to: 150, shouldCropToSquare: true)
        }
    }
    
    func deleteImage(at path: String?) async throws {
        let url = try createURL(from: path)
        try FileManager.default.removeItem(at: url)
    }
}

// private method 분리
extension ImageRepository {
    /// image를 목표 사이즈로 렌더링 하여 반환
    private func resizeImage(
        _ image: UIImage,
        to size: CGFloat,
        shouldCropToSquare: Bool = false
    ) -> UIImage {
        // 이미지 비율을 이용하여 이미지의 긴 변을 목표 사이즈에 맞게 생성
        let aspectRatio: CGFloat = image.size.width / image.size.height
        let newSize: CGSize = {
            if image.size.width > image.size.height {
                return CGSize(width: size, height: size / aspectRatio)
            } else {
                return CGSize(width: size * aspectRatio, height: size)
            }
        }()
        
        //새로운 사이즈로 이미지 렌더링
        if shouldCropToSquare {
            // 정사각형 이미지로 만들기 위해, 실제 렌더러 사이즈는 (size, size)
            // newSize에 맞게 이미지를 리사이즈한 후 정중앙에서 crop 처리
            let scale = size / min(newSize.width, newSize.height)
            let scaledWidth = newSize.width * scale
            let scaledHeight = newSize.height * scale
            let xOffset = (scaledWidth - size) / 2.0
            let yOffset = (scaledHeight - size) / 2.0
            
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
            return renderer.image { _ in
                image.draw(in: CGRect(x: -xOffset, y: -yOffset, width: scaledWidth, height: scaledHeight))
            }
        } else {
            // 그냥 리사이즈만 수행
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    }
    
    /// 이미지를 FileManager를 통해 기기에 저장하는 함수
    private func saveImageAsFile(_ image: UIImage, to path: String) throws {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        let fileURL: URL = directory.appendingPathComponent("\(path).jpeg")
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw FileError.imageSaveFailed
        }
    }
    
    /// FileManager를 통해 이미지를 불러오는 함수
    private func loadImageFile(from path: String) throws -> UIImage {
        let url: URL = try createURL(from: path)
        guard let data: Data = FileManager.default.contents(
            atPath: url.path()
        ) else {
            throw FileError.imageFetchFailed
        }
        guard let loadedImage: UIImage = UIImage(data: data) else { throw FileError.imageFetchFailed }
        
        return loadedImage
    }
    
    /// path로 url 생성하는 메서드
    private func createURL(from path: String?) throws -> URL {
        guard let path: String = path else { throw FileError.invalidPath }
        guard let url: URL = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appending(path: "\(path).jpeg") else {
            throw FileError.imageSearchFailed
        }
        return url
    }
}
