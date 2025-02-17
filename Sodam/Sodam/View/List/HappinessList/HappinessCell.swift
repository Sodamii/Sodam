//
//  HappinessCell.swift
//  Sodam
//
//  Created by EMILY on 05/02/2025.
//

import SwiftUI

struct HappinessCell: View {
    let store: HappinessCellStore
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            if let image = store.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 15))
            }
            VStack(alignment: .leading) {
                Text(store.content)
                    .font(.mapoGoldenPier(FontSize.body))
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .padding(.bottom, 8)
                
                Text(store.date)
                    .font(.mapoGoldenPier(FontSize.timeStamp))
                    .foregroundStyle(.gray)
            }
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct HappinessCellStore {
    let image: UIImage?
    let content: String
    let date: String
}
