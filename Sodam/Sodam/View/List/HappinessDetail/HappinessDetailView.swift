//
//  HappinessDetailView.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import SwiftUI

struct HappinessDetailView: View {
    
    @ObservedObject var viewModel: HappinessDetailViewModel
    
    @State private var deleteAlertPresented: Bool = false
    
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
            
            ToolbarItem(placement: .topBarTrailing) {
                if viewModel.isCurrentHangdam {
                    Button {
                        
                    } label: {
                        Image(systemName: "pencil")
                            .bold()
                            .foregroundStyle(Color.textAccent)
                            .hidden()   // 행복 수정 기능 구현까지 버튼 숨김
                    }
                } else {
                    Button {
                        deleteAlertPresented = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.textAccent)
                    }
                }
            }
        }
        
        .alert(
            AlertCase.deleteHappiness.title,
            isPresented: $deleteAlertPresented,
            actions: {
                Button("취소", role: .cancel) { }
                Button("삭제", role: .destructive) {
                    viewModel.deleteHappiness()
                    dismiss()
                }
            },
            message: {
                Text(AlertCase.deleteHappiness.message)
            }
        )
    }
}

#Preview {
}
