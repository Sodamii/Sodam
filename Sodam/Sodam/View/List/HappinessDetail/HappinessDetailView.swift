//
//  HappinessDetailView.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import SwiftUI

struct HappinessDetailView: View {
    
    @ObservedObject var viewModel: HappinessDetailViewModel
    @State private var isAlertPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if let imagePath = viewModel.content.happinessImagePath {
                        Image(uiImage: self.viewModel.getImage(from: imagePath))
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 15))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.cellBackground))
                    }
                    
                    Text(viewModel.content.happinessContent)
                        .appFont(size: .body2)
                        .lineSpacing(10)
                        .foregroundStyle(Color(UIColor.darkGray))
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity)
            .background(Color.viewBackground)
            .padding()
            .padding(.bottom, 32)
            .tabBarVisibility(false)
        }
        .background(Color.viewBackground.ignoresSafeArea())
        .ignoresSafeArea(edges: .bottom)
        .navigationBarTitleDisplayMode(.inline)
        .tint(.textAccent)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.content.happinessDate)
                    .appFont(size: .subtitle)
                    .foregroundStyle(Color.textAccent)
            }
            if viewModel.isCanDelete {
                ToolbarItem(placement: .topBarTrailing) {
                    Button( action: {
                        isAlertPresented = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        
        .alert(
            "정말 삭제하시겠습니까?",
            isPresented: $isAlertPresented,
            actions: {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    viewModel.deleteHappiness()
                    dismiss()
                }
            },
            message: {
                Text("삭제한 행복은 되돌릴 수 없습니다.")
            }
        )
    }
}

#Preview {
}
