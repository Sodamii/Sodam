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
    var images: [UIImage]
}

final class WriteModel {
    
    private(set) var post: Post {
        didSet {
            onPostUpdated?(post)
        }
    }
    
    var onPostUpdated: ((Post) -> Void)?
    
    init(initialPost: Post = Post(text: "", images: [])) {
        post = initialPost
    }
    
    func updateText(_ text: String) {
        post.text = text
    }
    
    func addImage(_ image: UIImage) {
        post.images.append(image)
    }
    
    func removeImage(at index: Int) {
        post.images.remove(at: index)
    }
}
