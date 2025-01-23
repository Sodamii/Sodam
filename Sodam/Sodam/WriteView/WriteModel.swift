//
//  WriteModel.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit

// 작성된 텍스트와 사진 저장
struct Post {
    var text: String
    var images: [UIImage]
}

final class WriteModel {
    
    private(set) var post: Post {
        didSet {
            onPostUpdated?(post) // post가 변경되면 클로저 호출
        }
    }
    
    // 클로저 정의
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
