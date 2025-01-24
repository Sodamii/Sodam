//
//  HappinessDetailView.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import SwiftUI

struct HappinessDetailView: View {
    
    let date: String
    let imgae: Image?
    let text: String
    
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.primary)
                    .frame(width: 200, height: 200)
                Text(text)
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .navigationTitle(date)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button( action: {
                    isAlertPresented = true
                }) {
                    Image(systemName: "trash")
                        .foregroundStyle(.gray)
                }
            }
        }
        .background(Color.viewBackground)
        .alert("정말로 삭제하시겠습니까?", isPresented: $isAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("삭제", role: .destructive) {
                // 데이터 삭제 메서드
            }
        }
    }
    
}

#Preview {
    HappinessDetailView(date: "2002.12.12", imgae: nil, text: "오늘 복권 1등 당첨됐다. 행담이 회사 내가 사주지.")
}

