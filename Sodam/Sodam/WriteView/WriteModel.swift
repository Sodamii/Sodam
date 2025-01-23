//
//  WriteModel.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit

// 작성된 텍스트와 사진을 저장하는 구조체
struct Post {
    var content: String // 작성된 텍스트
    var images: [UIImage] // 첨부된 이미지 배열
}

final class WriteModel {
    
    private(set) var post: Post {
        didSet {
            onPostUpdated?(post) // post가 변경되면 클로저 호출
        }
    }
    
    // 데이터 변경 시 호출될 클로저
    var onPostUpdated: ((Post) -> Void)?
    
    init(initialPost: Post = Post(content: "", images: [])) {
        // 초기 Post 데이터 설정
        post = initialPost
    }
    
    // MARK: - 데이터 업데이트 메서드
    
    // 텍스트 업데이트 메서드
    func updateText(_ text: String) {
        post.content = text
    }
    
    // 이미지 추가 메서드
    func addImage(_ image: UIImage) {
        post.images.append(image)
    }
    
    // 이미지 삭제 메서드
    func removeImage(at index: Int) {
        post.images.remove(at: index)
    }
}
