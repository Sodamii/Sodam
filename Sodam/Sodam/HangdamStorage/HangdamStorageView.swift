//
//  HangdamStorageView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStorageView: View {
    
    @StateObject private var viewModel: HangdamStorageViewModel
    
    init(viewModel: HangdamStorageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    NavigationLink {
                        HappinessListView(hangdam: $viewModel.currentHangdam.wrappedValue)
                    } label: {
                        HangdamStatusView(size: geometry.size, hangdam: $viewModel.currentHangdam)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                    
                    Text("행담이 보관함")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.mapoGoldenPier(27))
                        .foregroundStyle(Color.textAccent)
                        .padding(.top)
                    
                    ScrollView {
                        HangdamGridView(hangdamList: $viewModel.storedHangdamList)
                            .padding(.bottom)
                    }
                    .scrollIndicators(.hidden)
                }
                .padding(.top)
                .padding(.horizontal)
            }
            .background(Color.viewBackground)
            .onAppear {
                withAnimation {
                    if let tabBarController = getRootTabBarController() {
                        tabBarController.tabBar.isHidden = false
                    }
                    viewModel.loadHangdamData()
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
