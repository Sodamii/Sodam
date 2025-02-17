//
//  HangdamStorageView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStorageView: View {
    
    @ObservedObject var viewModel: HangdamStorageViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                HStack(alignment: .bottom) {
                    HangdamStorageTitle()
                    
                    HangdamCountTitle(count: viewModel.hangdamGridStores.count)
                }
                
                if viewModel.hangdamGridStores.isEmpty {
                    HangdamEmptyView()
                } else {
                    ScrollView {
                        HangdamGridView(viewModel: viewModel)
                            .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.horizontal)
            .background(Color.viewBackground)
            .tabBarVisibility(true)
            .onAppear {
                viewModel.loadHangdams()
            }
        }
        .tint(.textAccent)
    }
}

fileprivate struct HangdamStorageTitle: View {
    var body: some View {
        Text("행담이 보관함")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.mapoGoldenPier(27))
            .foregroundStyle(Color.textAccent)
            .padding(.top)
    }
}

fileprivate struct HangdamCountTitle: View {
    
    let count: Int
    
    var body: some View {
        Text("다 자란 행담이 : \(count)")
            .font(.mapoGoldenPier(15))
            .foregroundStyle(Color.white)
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(Capsule().fill(Color.buttonBackground))
    }
}

#Preview {
    HangdamStorageView(viewModel: HangdamStorageViewModel(hangdamRepository: HangdamRepository()))
}
