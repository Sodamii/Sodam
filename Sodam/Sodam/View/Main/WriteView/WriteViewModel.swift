//
//  WriteViewModel.swift
//  Sodam
//
//  Created by 박민석 on 1/22/25.
//

import UIKit

final class WriteViewModel {
    
    private let writeModel: WriteModel
    private let happinessRepository: HappinessRepository
    private let currentHangdamID: String
    private let imageManager: ImageManager = .init()
    
    var isPostSubmitted: Bool = false // 작성 완료, 임시 저장 구분하기 위한 Bool 타입 변수. 첫 작성을 고려하여 초기값은 false
    
    init(writeModel: WriteModel = .init(),
         repository: HappinessRepository = HappinessRepository(),
         currentHangdamID: String
    ) {
        self.writeModel = writeModel
        self.happinessRepository = repository
        self.currentHangdamID = currentHangdamID
    }
}

// MARK: - 입력을 모델에 전달
extension WriteViewModel {
    // 텍스트 업데이트 메서드
    func updateText(_ text: String) {
        writeModel.updateText(text)
    }
    
    // 작성 완료 이벤트 처리
    func submitPost(completion: @escaping () -> Void) {
        let imagePaths = saveImages(writeModel.post.images)
        
        let newHappiness: HappinessDTO = HappinessDTO(content: text, date: Date.now, imagePaths: imagePaths, hangdamID: currentHangdamID)
        happinessRepository.createHappiness(newHappiness)
        
        isPostSubmitted = true
        // post 초기화
        writeModel.resetPost()
        // 작성 완료 알림 표시 후 모달 닫기
        completion()
    }
    
    func addImage(_ image: UIImage) {
        writeModel.addImage(image)
    }
    
    // 뷰에서 이미지 제거
    func removeImage(at index: Int) {
        writeModel.removeImage(at: index)
    }
    
    // 작성 취소 이벤트 처리
    func cancelPost() {
        saveTemporaryPost()
        isPostSubmitted = false
    }
}

// MARK: - 결과를 뷰에 전달
extension WriteViewModel {
    // Model의 데이터 변경을 관찰
    func bindPostUpdated(completion: @escaping (Post) -> Void) {
        writeModel.onPostUpdated = completion
    }
    
    // Model의 이미지 데이터를 View에 전달
    var images: [UIImage] {
        return writeModel.post.images
    }
    
    // Model의 텍스트 데이터를 View에 전달
    var text: String {
        return writeModel.post.content
    }
}

// MARK: - 이미지 경로 생성 및 저장
extension WriteViewModel {
    // 이미지 경로 생성 및 파일매니저에 저장하기 위한 메서드
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
    
    // 임시 저장을 위한 메서드
    func saveTemporaryPost() {
        let imagePaths = saveImages(writeModel.post.images)
        
        UserDefaultsManager.shared.saveContent(writeModel.post.content)
        UserDefaultsManager.shared.saveImagePath(imagePaths)
    }
    
    // 임시 저장된 글 불러오는 메서드
    func loadTemporaryPost() {
        guard let content = UserDefaultsManager.shared.getContent(), // 임시 저장된 글 불러오기
              let imagePaths = UserDefaultsManager.shared.getImagePath() // 임시 저장된 이미지 경로 불러오기
        else {
            // 불러올 데이터가 없는 경우 종료
            return
        }
        
        // 불러온 글 내용을 모델에 업데이트
        writeModel.updateText(content)
        
        for imagePath in imagePaths {
            if let result = imageManager.getImage(with: imagePath) { // ImageManager의 getImage 호출해서 이미지 불러오기
                // 뷰에 이미지 추가
                writeModel.addImage(result)
            }
        }
    }
}
