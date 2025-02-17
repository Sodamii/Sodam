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
    @Environment(\.dismiss) private var dismiss
    @State var isBackButtonHidden: Bool // 기록 탭으로 진입하면 뒤로가기 숨기기
    
    private let cornerRadius: CGFloat = 15
    
    init(isBackButtonHidden: Bool = false) {
        self._viewModel = StateObject(wrappedValue: HappinessListViewModel())
        self._isBackButtonHidden = State(initialValue: isBackButtonHidden)
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HangdamStatusView(size: geometry.size, hangdam: $viewModel.hangdam)
                        .clipShape(.rect(cornerRadius: cornerRadius))
                    Text("\($viewModel.hangdam.wrappedValue.name ?? "행담이")가 먹은 기억들")
                        .frame(maxWidth: .infinity, maxHeight: 35, alignment: .leading)
                        .font(.mapoGoldenPier(FontSize.title2))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(Color.textAccent)
                        .padding(.vertical, 8)
                    
                    if viewModel.happinessList.count > 0 {
                        List {
                            ForEach(viewModel.happinessList, id: \.self) { happiness in
                                NavigationLink (destination: {
                                    HappinessDetailView(
                                        viewModel: HappinessDetailViewModel(happiness: happiness, happinessRepository: viewModel.getHappinessRepository()),
                                        isCanDelete: viewModel.hangdam.endDate == nil ? false : true
                                    )
                                }, label: {
                                    HappinessCell(
                                        image: viewModel.getThumnail(from: happiness.imagePaths.first),
                                        content: happiness.content,
                                        date: happiness.formattedDate
                                    )
//                                    HappinessCell(happiness: happiness, happinessRepository: viewModel.getHappinessRepository(), isCanDelete: viewModel.hangdam.endDate == nil ? false : true, image: viewModel.getThumnail(from: happiness.imagePaths.first))
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
            .onAppear {
                viewModel.reloadData() // onAppear에서 실행
                print("[HappinessListView] .onAppear - 데이터 리로드")
            }
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

