//
//  WriteViewModel.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit

/// 뷰에 작성 내용 전달
protocol WriteViewModelDelegate: AnyObject {
    func didUpdatePost(_ text: String, _ isEmpty: Bool)
}

final class WriteViewModel {

    weak var delegate: WriteViewModelDelegate?

    private let happinessRepository: HappinessRepository
    private let currentHangdamID: String
    private let imageManager: ImageManager = .init()

    var isPostSubmitted: Bool = false // 작성 완료, 임시 저장 구분하기 위한 Bool 타입 변수. 첫 작성을 고려하여 초기값은 false

    private var post: Post

    init(
         repository: HappinessRepository = HappinessRepository(),
         currentHangdamID: String
    ) {
        self.happinessRepository = repository
        self.currentHangdamID = currentHangdamID
        self.post = Post(content: "", images: [])
    }
}

// MARK: - 입력 이벤트 처리
extension WriteViewModel {
    /// 텍스트 업데이트 메서드
    func updateText(_ text: String) {
        post.content = text
        delegate?.didUpdatePost(text, post.images.isEmpty)
    }

    /// 뷰에 이미지 추가 메서드
    func addImage(_ image: UIImage) {
        post.images.append(image)
        delegate?.didUpdatePost(post.content, post.images.isEmpty)
    }

    // 뷰에서 이미지 제거 메서드
    func removeImage(at index: Int) {
        guard index < post.images.count else { return }
        post.images.remove(at: index)
        delegate?.didUpdatePost(post.content, post.images.isEmpty)
    }

    /// 작성 완료 이벤트 처리 메서드
    func submitPost(completion: @escaping () -> Void) {
        let imagePaths = saveImages(post.images)

        let newHappiness: HappinessDTO = HappinessDTO(content: post.content, date: Date.now, imagePaths: imagePaths, hangdamID: currentHangdamID)
        happinessRepository.createHappiness(newHappiness)

        isPostSubmitted = true
        UserDefaultsManager.shared.saveDiaryWrittenStatus(true)

        // post 초기화
        resetPost()
        delegate?.didUpdatePost(post.content, post.images.isEmpty)

        // 작성 완료 알림 표시 후 모달 닫기
        completion()
    }

    /// 작성 취소 이벤트 처리 메서드
    func cancelPost() {
        saveTemporaryPost()
        isPostSubmitted = false
    }

    /// 제출 완료시 작성 내용 초기화 메서드
    func resetPost() {
        post = Post(content: "", images: [])
        delegate?.didUpdatePost(post.content, post.images.isEmpty)
    }
}

// MARK: - 뷰에서 사용할 모델 정보 전달
extension WriteViewModel {

    // 이미지 갯수 반환
    var imageCount: Int {
        return post.images.count
    }

    // 특정 셀의 이미지 반환
    func image(at index: Int) -> UIImage? {
        guard index < post.images.count else { return nil }
        return post.images[index]
    }
}

// MARK: - 이미지 경로 생성 및 저장
extension WriteViewModel {
    /// 이미지 경로 생성 및 파일매니저에 저장하기 위한 메서드
    private func saveImages(_ images: [UIImage]) -> [String] {
        var imagePaths: [String] = []

        for image in images {
            let imagePath = imageManager.nameImagePath() // ImageManager의 nameImagePath 호출
            imageManager.saveImage(image, with: imagePath) // ImageManager의 saveImage 호출
            imagePaths.append(imagePath)
        }

        // 임시 저장과 영구 저장에서 사용할 imagePath 배열 반환
        return imagePaths
    }

    /// 임시 저장을 위한 메서드
    func saveTemporaryPost() {
        let imagePaths = saveImages(post.images)

        UserDefaultsManager.shared.saveContent(post.content)
        UserDefaultsManager.shared.saveImagePath(imagePaths)
    }

    /// 임시 저장된 글 불러오는 메서드
    func loadTemporaryPost() {
        guard let content = UserDefaultsManager.shared.getContent(), // 임시 저장된 글 불러오기
              let imagePaths = UserDefaultsManager.shared.getImagePath() // 임시 저장된 이미지 경로 불러오기
        else {
            // 불러올 데이터가 없는 경우 종료
            return
        }

        // 불러온 글 내용을 모델에 업데이트
        updateText(content)

        for imagePath in imagePaths {
            if let result = imageManager.getImage(with: imagePath) { // ImageManager의 getImage 호출해서 이미지 불러오기
                // 뷰에 이미지 추가
                addImage(result)
            }
        }
    }
}
