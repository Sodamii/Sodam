//
//  ImageManager + Extension.swift
//  Sodam
//
//  Created by 박진홍 on 2/20/25.
//

import UIKit

extension ImageManager {
    func saveImageAsync(_ image: UIImage, to imagePath: String, size: CGFloat = 450) async throws {
        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
            Task.detached(priority: .userInitiated) {
                guard let self = self else { return continuation.resume(throwing: DataError.selfIsNil)}
                let resizedImage = self.resizeImage(image, resizeFloat: size)
                self.saveImageAsFile(image: resizedImage, imagePath: imagePath)
                continuation.resume(returning: ())
            }
        }
    }
}
