//
//  WriteModel.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/22/25.
//

import UIKit
import AVFoundation

// 작성된 텍스트와 사진 저장
struct Post {
    var text: String
    var image: UIImage?
}

final class WriteModel {
    // 카메라 권한 요청
    func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { isAuthorized in
            completion(isAuthorized)
        }
    }
}
