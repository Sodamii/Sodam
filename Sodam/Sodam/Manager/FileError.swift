//
//  FileError.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import Foundation

enum FileError: Error {
    case imageResizeFailed
    
    // 디버깅용 print 구문
    var localizedDescription: String {
        switch self {
        case .imageResizeFailed: "[FileManager Error] image resizing 실패"
        }
    }
    
    // 사용자에게 띄울 alert에 넣을 구문
    var alertDescription: String {
        switch self {
        default: "이미지 업로드에 문제가 생겼어요🥲"
        }
    }
}
