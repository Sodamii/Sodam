//
//  HangdamStorageView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStorageView: View {
    
    @State var mockHangdam: MockHangdam = .mockHangdam
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    NavigationLink {
                        HappinessListView()
                    } label: {
                        HangdamStatusView(size: geometry.size, mockHangdam: $mockHangdam)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                    
                    Text("행담이 보관함")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.mapoGoldenPier(27))
                        .foregroundStyle(Color.textAccent)
                        .padding(.top)
                    
                    ScrollView {
                        HangdamGridView(mockHangdam: $mockHangdam)
                            .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .background(Color.viewBackground)
        }
        .tint(.textAccent)
    }
}

#Preview {
    HangdamStorageView()
}
