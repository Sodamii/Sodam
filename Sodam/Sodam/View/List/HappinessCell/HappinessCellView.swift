//
//  HappinessCell.swift
//  Sodam
//
//  Created by EMILY on 05/02/2025.
//

import SwiftUI

struct HappinessCellView: View {
    private let viewModel: HappinessCellViewModel

    init(viewModel: HappinessCellViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if let image = viewModel.getThumbnail() { // 추후 이미지가 여럿 생기더라도 여긴 첫 이미지를 사용
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 15))
            }
            VStack(alignment: .leading) {
                Text(viewModel.content.happinessContent)
                    .appFont(size: .body2)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .padding(.bottom, 8)
                
                Text(viewModel.content.date)
                    .appFont(size: .caption)
                    .foregroundStyle(.gray)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
