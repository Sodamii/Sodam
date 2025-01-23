//
//  HappinessView.swift
//  Sodam
//
//  Created by 박진홍 on 1/21/25.
//

import SwiftUI

struct HappinessListView: View {
    @State var mockHangdam: MockHangdam = .mockHangdam
    
    private let cornerRadius: CGFloat = 15
    private var array: [Int] = [1,2,3,4,5] // mock happiness가 hasable하지 않아 list 테스트용 배열 생성함.
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                HangdamStatusView(size: geometry.size, mockHangdam: $mockHangdam)
                    .clipShape(.rect(cornerRadius: cornerRadius))

                Text("엄마는 아무것도 모른담이가 먹고 자란 기억들")
                    .frame(maxWidth: .infinity,maxHeight: 35, alignment: .leading)
                    .font(.mapoGoldenPier(FontSize.title))
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    .foregroundStyle(Color.textAccent)
                    .padding(.top)

                List {
                    ForEach(array, id: \.self) { value in
                        HStack {
                            Rectangle() // 사진 대체용
                                .frame(width: 90, height: 120)
                                .clipShape(.rect(cornerRadius: cornerRadius))
                            
                            VStack(alignment: .leading) {
                                Text("나는 어제 엽떡을 먹어서 행복했다. 근데 오늘 엽떡이 너무 매워서 완전 피똥쌌다. 힘들다. 다시느 ㄴ엽떡을 안 머거야지")
                                    .font(.mapoGoldenPier(FontSize.body))
                                    .lineLimit(2)
                                    .frame(height: 50, alignment: .topLeading)
                                Text("\(mockHangdam.startDate?.toString ?? "")")
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
                .listRowSpacing(20)
                .listStyle(.plain)
            }
        }
        .padding([.top, .horizontal])
        .background(Color.viewBackground)
    }
}

extension HappinessListView {
    enum FontSize{
        static let title: CGFloat = 27
        static let body: CGFloat = 16
        static let timeStamp: CGFloat = 14
    }
}

#Preview {
    HappinessListView()
}

