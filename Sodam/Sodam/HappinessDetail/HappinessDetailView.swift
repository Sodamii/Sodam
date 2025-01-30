//
//  HappinessDetailView.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import SwiftUI

struct HappinessDetailView: View {
    
    var viewModel: HappinessDetailViewModel
    @State private var isAlertPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: HappinessDetailViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        ScrollView {
            VStack {
                if let imagePath = viewModel.happiness.imagePaths.first {
                    // TODO: 이미지 호출하여 뷰로 구성하는 메서드 필요,
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.primary)
                        .frame(width: 200, height: 200)
                }
                
                Text(viewModel.happiness.content)
                    .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .navigationTitle(viewModel.happiness.date.toFormattedString)
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
        .alert("정말 삭제하시겠습니까?", isPresented: $isAlertPresented) {
            Button("취소", role: .cancel) { }
            Button("삭제", role: .destructive) {
                viewModel.deleteHappiness()
                dismiss()
            }
        } message: {
            Text("삭제한 행복은 되돌릴 수 없습니다.")
        }
        //        .sheet(isPresented: $isAlertPresented) {
        //            CustomAlertRepresentable(
        //                alertBuilder: CustomAlertBuilder()
        //                    .setTitle(to: "you real?")
        //                    .setMessage(to: "you can't undo")
        //                    .setBackground(color: .cellBackground)
        //                    .setAlertFont(font: .gowunBatang(type: .regular, size: 16))
        //                    .setTitleColor(to: .textAccent)
        //                    .setMessageFontColor(to: .darkGray)
        //                    .addAction(title: "확인", style: .onlyYes) { _ in }
        //                    .addAction(title: "취소", style: .canCancle) { _ in }
        //            )
        //        }
    }
    
}

#Preview {
//    HappinessDetailView(viewModel: HappinessDetailViewModel())
}

