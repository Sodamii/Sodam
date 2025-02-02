//
//  HappinessView.swift
//  Sodam
//
//  Created by 박진홍 on 1/21/25.
//

import SwiftUI
import Combine

struct HappinessListView: View {
    
    @StateObject var viewModel: HappinessListViewModel
 
    private let cornerRadius: CGFloat = 15
    
    init(hangdam: HangdamDTO) {
        self._viewModel = StateObject(wrappedValue: HappinessListViewModel(hangdam: hangdam))
    }
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HangdamStatusView(size: geometry.size, hangdam: $viewModel.hangdam)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                    
                    if let happinessList = $viewModel.happinessList.wrappedValue,
                       !happinessList.isEmpty {
                        Text("\($viewModel.hangdam.wrappedValue.name ?? "이름없는 ")가 먹은 기억들")
                            .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                            .font(.mapoGoldenPier(FontSize.title2))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(Color.textAccent)
                            .padding(.vertical, 8)
                        
                        List {
                            ForEach(happinessList, id: \.self) { happiness in
                                NavigationLink(destination: HappinessDetailView(viewModel: HappinessDetailViewModel(happiness: happiness))) {
                                    HStack {
                                        Rectangle() // 사진 대체용
                                            .frame(width: 90, height: 120)
                                            .clipShape(.rect(cornerRadius: cornerRadius))
                                        
                                        VStack(alignment: .leading) {
                                            Text(happiness.content)
                                                .font(.mapoGoldenPier(FontSize.body))
                                                .lineLimit(2)
                                                .frame(height: 50, alignment: .topLeading)
                                            
                                            Text(happiness.date.toFormattedString)
                                                .font(.mapoGoldenPier(FontSize.timeStamp))
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(.leading)
                                    }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(
                                    RoundedRectangle(cornerRadius: cornerRadius)
                                        .foregroundStyle(Color.cellBackground)
                                )
                            }
                        }
                        .scrollIndicators(.hidden)
                        .listRowSpacing(20)
                        .listStyle(.plain)
                    } else {
                        Text("아직 가진 기억이 없어요.ㅜ.ㅜ")
                            .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                            .font(.mapoGoldenPier(FontSize.title2))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(Color.textAccent)
                            .padding(.vertical, 8)
                    }
                    
                }
            }
            .padding([.top, .horizontal])
            .background(Color.viewBackground)
            .onAppear {
                if let tabBarController = getRootTabBarController() {
                    tabBarController.tabBar.isHidden = true
                }
                viewModel.reloadData()
                print("list 뷰 등장 및 데이터 리로드")
            }
        }
    }
    
    private func getRootTabBarController() -> UITabBarController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = scene.delegate as? SceneDelegate,
              let rootViewController = sceneDelegate.window?.rootViewController else {
            return nil
        }
        
        return rootViewController as? UITabBarController
    }
}

extension HappinessListView {
    enum FontSize{
        static let title: CGFloat = 27
        static let title2: CGFloat = 24
        static let body: CGFloat = 16
        static let timeStamp: CGFloat = 14
    }
}

extension HappinessListView {
    
}

#Preview {
    let hangdamRepository: HangdamRepository = HangdamRepository()
    HappinessListView(hangdam: hangdamRepository.getCurrentHangdam())
}

