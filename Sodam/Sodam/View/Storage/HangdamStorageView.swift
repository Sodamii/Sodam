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
                    Text("행담이 보관함")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.mapoGoldenPier(27))
                        .foregroundStyle(Color.textAccent)
                        .padding(.top)
                    
                    Text("다 자란 행담이 : \($viewModel.storedHangdams.wrappedValue.count)")
                        .font(.mapoGoldenPier(15))
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 12)
                        .background(Capsule().fill(Color.buttonBackground))
                }
                if $viewModel.storedHangdams.wrappedValue.count == 0 {
                    VStack(alignment: .leading, spacing: 7) {
                        Text("다 자란 행담이가 여기에 보관됩니다.")
                        Text("행담이에게 행복을 주고 성장시켜보세요!")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.mapoGoldenPier(20))
                    .foregroundStyle(Color.gray)
                } else {
                    ScrollView {
                        HangdamGridView(hangdams: $viewModel.storedHangdams)
                            .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding(.horizontal)
            .background(Color.viewBackground)
            .onAppear {
                withAnimation {
                    if let tabBarController = getRootTabBarController() {
                        tabBarController.tabBar.isHidden = false
                    }
                    viewModel.loadHangdams()
                }
            }
        }
        .tint(.textAccent)
    }
    
    // MARK: - Helper method
    
    private func getRootTabBarController() -> UITabBarController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let rootViewController = sceneDelegate.window?.rootViewController else {
            return nil
        }
        return rootViewController as? UITabBarController
    }
}

#Preview {
    HangdamStorageView(viewModel: HangdamStorageViewModel(hangdamRepository: HangdamRepository()))
}
