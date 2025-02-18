//
//  HappinessView.swift
//  Sodam
//
//  Created by 박진홍 on 1/21/25.
//

import SwiftUI
import Combine

struct HappinessListView: View {
    @ObservedObject private var viewModel: HappinessListViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let isBackButtonHidden: Bool // 기록 탭으로 진입하면 뒤로가기 숨기기
    private let cornerRadius: CGFloat = 15
    
    init(viewModel: HappinessListViewModel, isBackButtonHidden: Bool) {
        self.viewModel = viewModel
        self.isBackButtonHidden = isBackButtonHidden
    }
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HangdamStatusView(size: geometry.size, content: $viewModel.statusContent)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                    Text(viewModel.listContent.title)
                        .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                        .font(.mapoGoldenPier(FontSize.title2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(Color.textAccent)
                        .padding(.vertical, 8)
                    
                    if !viewModel.listConfigs.isEmpty {
                        List {
                            ForEach(viewModel.listConfigs, id: \.self) { config in
                                NavigationLink (
                                    destination: {
                                        HappinessDetailView(
                                            viewModel: viewModel.detailViewModel(for: config
                                                                                
                                                                                )
                                        )
                                    },
                                    label: {
                                        HappinessCellView(
                                            viewModel: HappinessCellViewModel(
                                                content: config.cellContent,
                                                thumbnailFetcher: viewModel.cellThumbnailFetcher
                                            )
                                        )
                                    }
                                )
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: cornerRadius).foregroundStyle(Color.cellBackground)
                            )
                            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        }
                        .scrollIndicators(.hidden)
                        .listRowSpacing(16)
                        .listStyle(.plain)
                    } else {
                        VStack(alignment:.center) {
                            Spacer()
                            Text(viewModel.listContent.emptyComment)
                                .frame(maxWidth: .infinity, maxHeight: 35, alignment: .center)
                                .font(.mapoGoldenPier(20))
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .foregroundStyle(Color.gray)
                                .padding(.vertical, 8)
                            Spacer()
                        }
                    }
                }
                .tabBarVisibilityByTab()
            }
            .padding([.top, .horizontal])
            .background(Color.viewBackground)
            .onAppear {
                viewModel.reloadData() // onAppear에서 실행
                print("[HappinessListView] .onAppear - 데이터 리로드")
            }
        }
        .tint(.textAccent)
    }
}

enum FontSize {
    static let title: CGFloat = 27
    static let title2: CGFloat = 24
    static let body: CGFloat = 16
    static let timeStamp: CGFloat = 14
}
