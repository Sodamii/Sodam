//
//  HangdamEmptyView.swift
//  Sodam
//
//  Created by EMILY on 11/02/2025.
//

import SwiftUI

struct HangdamEmptyView: View {
    var body: some View {
        Text("다 자란 행담이가 여기에 보관됩니다.\n행담이에게 행복을 주고 성장시켜보세요!")
            .font(.appFont(size: .subtitle))
            .foregroundStyle(Color.gray)
            .minimumScaleFactor(0.7)
            .lineLimit(2)
            .lineSpacing(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HangdamEmptyView()
}
