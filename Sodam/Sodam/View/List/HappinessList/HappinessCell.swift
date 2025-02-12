//
//  HappinessCell.swift
//  Sodam
//
//  Created by EMILY on 05/02/2025.
//

// TODO:

import SwiftUI

struct HappinessCell: View {
    
//    let happiness: HappinessDTO
//    let happinessRepository: HappinessRepository
//    let isCanDelete: Bool
    
    let image: UIImage?
    let content: String
    let date: String
//    @State var viewModel: HappinessDetailViewModel?
    
    var body: some View {
//        NavigationLink {
//            if let viewModel = viewModel {
//                HappinessDetailView(viewModel: viewModel, isCanDelete: isCanDelete)
//            }
//        } label: {
            HStack(alignment: .center, spacing: 16) {
                if let image = image { // 추후 이미지가 여럿 생기더라도 여긴 첫 이미지를 사용
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 15))
                }
                VStack(alignment: .leading) {
//                    Text(happiness.content)
                    Text(content)
                        .font(.mapoGoldenPier(FontSize.body))
                        .foregroundStyle(.black)
                        .lineLimit(2)
                        .padding(.bottom, 8)
//                    Text(happiness.formattedDate)
                    Text(date)
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
