//
//  HangdamGridView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamGridView: View {
    
    @Binding var mockHangdam: MockHangdam
    
    let columns = Array(repeating: GridItem(spacing: 16), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            HangdamGrid(mockHangdam: $mockHangdam)
            HangdamGrid(mockHangdam: $mockHangdam)
            HangdamGrid(mockHangdam: $mockHangdam)
            HangdamGrid(mockHangdam: $mockHangdam)
            HangdamGrid(mockHangdam: $mockHangdam)
            HangdamGrid(mockHangdam: $mockHangdam)
        }
    }
}

fileprivate struct HangdamGrid: View {
    
    @Binding var mockHangdam: MockHangdam
    
    var body: some View {
        NavigationLink {
            HappinessListView()
        } label: {
            VStack(spacing: 1) {
                Image(.babyHangdam)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.imageBackground)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(mockHangdam.name)
                        .font(.maruburiot(type: .bold, size: 16))
                        .foregroundStyle(Color(uiColor: .darkGray))
                    
                    Text(mockHangdam.startDate?.toString ?? "")
                        .font(.maruburiot(type: .regular, size: 14))
                        .foregroundStyle(Color(uiColor: .gray))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom])
            }
            .background(Color.cellBackground)
            .clipShape(.rect(cornerRadius: 15))
        }
    }
}

#Preview {
    HangdamGridView(mockHangdam: .constant(.mockHangdam))
}
