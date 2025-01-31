//
//  FileError.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import Foundation

enum FileError: Error {
    case imageSaveFailed
    case imageFetchFailed
    case imageSearchFailed
    case imageDeleteFailed
    
    // 디버깅용 print 구문
    var localizedDescription: String {
        switch self {
        case .imageSaveFailed: "[FileManager Error] image 저장 실패"
        case .imageFetchFailed: "[FileManager Error] image 불러오기 실패"
        case .imageSearchFailed: "[FileManager Error] image 검색 실패"
        case .imageDeleteFailed: "[FileManager Error] image 삭제 실패"
        }
    }
    
    // 사용자에게 띄울 alert에 넣을 구문
    var alertDescription: String {
        switch self {
        case .imageSaveFailed: "이미지 업로드에 문제가 생겼어요🥲"
        case .imageFetchFailed: "이미지를 불러오는 데 문제가 생겼어요🥲"
        case .imageSearchFailed: "삭제할 이미지 검색에 실패했어요🥲"
        case .imageDeleteFailed: "기억 속 이미지 삭제가 제대로 이루어지지 않았어요🥲"
        }
    }
}
