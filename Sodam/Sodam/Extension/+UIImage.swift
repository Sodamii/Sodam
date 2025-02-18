//
//  GifHandler.swift
//  Sodam
//
//  Created by 손겸 on 1/23/25.
//

import UIKit

extension UIImage {
    // GIF 파일 이름을 받아서 애니메이션 이미지를 생성하는 메서드
    static func animatedImage(withGIFNamed name: String) -> UIImage? {

        // 메인 번들에서 GIF 파일의 URL을 가져옴
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            print("GIF 파일을 찾을 수 없습니다: \(name)")
            return nil
        }

        // GIF 파일을 데이터로 변환
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("GIF 파일을 데이터로 변환할 수 없습니다: \(name)")
            return nil
        }

        // 데이터를 사용하여 CGImageSource 생성
        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            print("GIF 소스를 생성할 수 없습니다: \(name)")
            return nil
        }

        // GIF 프레임 수를 가져옴
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]() // 애니메이션에 사용될 이미지 배열
        var duration = 0.0 // 애니메이션 총 지속 시간 (0으로 하면 반복됨)

        // 각 프레임을 순회하며 이미지와 지속 시간을 계산
        for index in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) {

                // CGImage를 UIImage로 변환하여 배열에 추가
                let image = UIImage(cgImage: cgImage)
                images.append(image)

                // GIF 속성에서 지연 시간을 가져와 총 지속 시간에 추가
                if let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
                   let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any] {
                    if let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double {
                        duration += delayTime
                    }
                }
            }
        }

        // 계산된 이미지 배열과 지속 시간을 사용하여 애니메이션 이미지 생성
        return UIImage.animatedImage(with: images, duration: duration)
    }
}
