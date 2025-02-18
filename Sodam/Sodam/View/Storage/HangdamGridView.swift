//
//  HangdamGridView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamGridView: View {

    @ObservedObject var viewModel: HangdamStorageViewModel

    let columns = Array(repeating: GridItem(spacing: 16), count: 2)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.hangdamGridStores.indices, id: \.self) { index in
                NavigationLink {
                    HappinessListView(viewModel: viewModel.happinessListViewModels[index], isBackButtonHidden: true)
                } label: {
                    HangdamGrid(store: viewModel.hangdamGridStores[index])
                }
            }
        }
    }
}

private struct HangdamGrid: View {
    let store: HangdamGridStore

    var body: some View {
        VStack(spacing: 1) {
            Image(.level4)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.imageBackground)
                .clipShape(.rect(cornerRadius: 15))
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text(store.name)
                    .font(.maruburiot(type: .bold, size: 16))
                    .foregroundStyle(Color(uiColor: .darkGray))
                Text(store.dateString)
                    .font(.maruburiot(type: .regular, size: 13))
                    .foregroundStyle(Color(uiColor: .gray))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .bottom])
        }
        .background(Color.cellBackground)
        .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    HangdamGridView(viewModel: .init(hangdamRepository: .init()))
}
