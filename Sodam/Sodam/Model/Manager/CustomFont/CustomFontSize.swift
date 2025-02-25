//
//  CustomFontSize.swift
//  Sodam
//
//  Created by EMILY on 19/02/2025.
//

import Foundation

enum CustomFontSize: CGFloat {
    case title1 = 28    // 제일 큰 title
    case title2 = 24    // 행담이 상태 뷰에서 행담이 이름 크기
    case subtitle = 20  // 행복 작성하기 버튼, d-MMM-yyyy 날짜 레이블, emptyview 글씨 크기
    case body1 = 18     // 랜덤 메시지 글씨 크기
    case body2 = 16     // writeview, detailview content, 설정 테이블 뷰 셀 label 글씨 크기
    case caption = 14   // startDate ~ endDate 글씨 크기
}
