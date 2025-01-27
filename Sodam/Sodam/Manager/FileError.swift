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
    
    // 디버깅용 print 구문
    var localizedDescription: String {
        switch self {
        case .imageSaveFailed: "[FileManager Error] image 저장 실패"
        case .imageFetchFailed: "[FileManager Error] image 불러오기 실패"
        }
    }
    
    // 사용자에게 띄울 alert에 넣을 구문
    var alertDescription: String {
        switch self {
        case .imageSaveFailed: "이미지 업로드에 문제가 생겼어요🥲"
        case .imageFetchFailed: "이미지를 불러오는 데 문제가 생겼어요🥲"
        }
    }
}
