//
//  HangdamStatusView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStatusView: View {
    
    @Binding var mockHangdam: MockHangdam
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(.babyHangdam)
                .resizable()
                .aspectRatio(contentMode: .fit)
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
        .background(Color.tabBackground)
    }
}

#Preview {
    HangdamStatusView(mockHangdam: .constant(.mockHangdam))
}
