//
//  HangdamStatusView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStatusView: View {
    
    let size: CGSize
    
    @Binding var mockHangdam: MockHangdam
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(.babyHangdam)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width / 3)
                .background(Color.imageBackground)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(mockHangdam.name)
                    .font(.mapoGoldenPier(24))
                Text("Lv.\(mockHangdam.level) 애기 행담이")
                    .font(.mapoGoldenPier(18))
                Text("\(mockHangdam.startDate?.toString ?? "") ~")
                    .font(.mapoGoldenPier(17))
            }
            .foregroundStyle(Color(uiColor: .white))
        }
        .padding(16)
        .frame(height: size.height / 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBackground)
    }
}

#Preview {
    HangdamStatusView(size: CGSize(width: 402, height: 716), mockHangdam: .constant(.mockHangdam))
}
