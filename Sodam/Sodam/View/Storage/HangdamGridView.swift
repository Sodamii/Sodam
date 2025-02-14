//
//  HangdamGridView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamGridView: View {
    
    @Binding var hangdams: [HangdamDTO]
    
    let columns = Array(repeating: GridItem(spacing: 16), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(hangdams.indices, id: \.self) { index in
                HangdamGrid(hangdam: $hangdams[index])
            }
        }
    }
}

fileprivate struct HangdamGrid: View {
    
    @Binding var hangdam: HangdamDTO
    
    var body: some View {
        NavigationLink {
            HappinessListView()
        } label: {
            VStack(spacing: 1) {
                Image(.level4)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(Color.imageBackground)
                    .clipShape(.rect(cornerRadius: 15))
                    .padding()

                VStack(alignment: .leading, spacing: 8) {
                    Text(hangdam.name ?? "이름잃은담이")
                        .font(.maruburiot(type: .bold, size: 16))
                        .foregroundStyle(Color(uiColor: .darkGray))
                    if let startDate = hangdam.startDate, let endDate = hangdam.endDate {
                        Text("\(startDate) ~ \(endDate)")
                            .font(.maruburiot(type: .regular, size: 13))
                            .foregroundStyle(Color(uiColor: .gray))
                            .minimumScaleFactor(0.6)
                            .lineLimit(1)
                    } else {
                        Text("")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.horizontal, .bottom])
            }
            .background(Color.cellBackground)
            .clipShape(.rect(cornerRadius: 15))
        }
    }
}

#Preview {
    let hangdamRepository: HangdamRepository = HangdamRepository()
    HangdamGridView(hangdams: .constant(hangdamRepository.getSavedHangdams()))
}
