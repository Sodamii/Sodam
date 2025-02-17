//
//  HappinessView.swift
//  Sodam
//
//  Created by 박진홍 on 1/21/25.
//

import SwiftUI
import Combine

struct HappinessListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HappinessListViewModel
    
    var isBackButtonHidden: Bool = false // 기록 탭으로 진입하면 뒤로가기 숨기기
    private let cornerRadius: CGFloat = 15
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HangdamStatusView(size: geometry.size, store: $viewModel.statusStore)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                    
                    Text(viewModel.title)
                        .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                        .font(.mapoGoldenPier(FontSize.title2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(Color.textAccent)
                        .padding(.vertical, 8)
                    
                    if !viewModel.happinessCellStores.isEmpty {
                        List {
                            ForEach(viewModel.happinessCellStores.indices, id: \.self) { i in
                                NavigationLink(
                                    destination: {
                                        HappinessDetailView(
                                            viewModel: viewModel.happinessDetailViewModels[i],
                                            isCanDelete: false
                                        )
                                    },
                                    label: {
                                        HappinessCell(store: viewModel.happinessCellStores[i])
                                })
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: cornerRadius)
                                    .foregroundStyle(Color.cellBackground)
                            )
                            .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        }
                        .scrollIndicators(.hidden)
                        .listRowSpacing(16)
                        .listStyle(.plain)
                    } else {
                        VStack(alignment:.center) {
                            Spacer()
                            Text("아직 가진 기억이 없어요😢")
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
            .toolbar {
                if !isBackButtonHidden { // ToolbarItem 자체를 조건문으로 감싸기
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(isBackButtonHidden)
            .onAppear {
                viewModel.reloadData()
            }
        }
    }
}

enum FontSize {
    static let title: CGFloat = 27
    static let title2: CGFloat = 24
    static let body: CGFloat = 16
    static let timeStamp: CGFloat = 14
}

#Preview {
    
}

