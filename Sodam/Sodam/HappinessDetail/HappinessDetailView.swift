//
//  HappinessDetailView.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import SwiftUI

struct HappinessDetailView: View {
    
    let date: String
    let image: UIImage?
    let text: String
    
    @State private var isAlertPresented: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                if let image = image {
                    Image(uiImage: image)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.primary)
                        .frame(width: 200, height: 200)
                }
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
        .sheet(isPresented: $isAlertPresented) {
            CustomAlertRepresentable(
                alertBuilder: CustomAlertBuilder()
                    .setTitle(to: "you real?")
                    .setMessage(to: "you can't undo")
                    .setBackground(color: .cellBackground)
                    .setAlertFont(font: .gowunBatang(type: .regular, size: 16))
                    .setTitleColor(to: .textAccent)
                    .setMessageFontColor(to: .darkGray)
                    .addAction(title: "확인", style: .onlyYes) { _ in }
                    .addAction(title: "취소", style: .canCancle) { _ in }
            )
        }
    }
    
}

#Preview {
    HappinessDetailView(date: "2002.12.12", image: nil, text: "오늘 복권 1등 당첨됐다. 행담이 회사 내가 사주지.")
}

