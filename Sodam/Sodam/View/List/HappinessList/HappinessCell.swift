//
//  HappinessCell.swift
//  Sodam
//
//  Created by EMILY on 05/02/2025.
//

// TODO:

import SwiftUI

struct HappinessCell: View {
    let content: HappinessCellContent
    
    var body: some View {
            HStack(alignment: .center, spacing: 16) {
                if let image = content.imagePath { // 추후 이미지가 여럿 생기더라도 여긴 첫 이미지를 사용
                    Image(uiImage: UIImage(systemName: "person")!) // TODO: 푸시 전 반드시 수정
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 15))
                }
                VStack(alignment: .leading) {
                    Text(content.happinessContent)
                        .font(.sejongGeulggot(16))
                        .foregroundStyle(.black)
                        .lineLimit(2)
                        .padding(.bottom, 8)
//                    Text(happiness.formattedDate)
                    Text(content.date)
                        .font(.mapoGoldenPier(FontSize.timeStamp))
                        .foregroundStyle(.gray)
                }
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
//            .onAppear {
//                viewModel = HappinessDetailViewModel(happiness: happiness, happinessRepository: happinessRepository)
//            }
//        }
    }
}
