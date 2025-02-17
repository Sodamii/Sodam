//
//  HangdamStatusView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStatusView: View {
    
    let size: CGSize
    @Binding var store: HangdamStatusStore
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            store.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width / 3)
                .background(Color.imageBackground)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(store.name)
                    .font(.maruburiot(type: .bold, size: store.hasName ? 25.0 : 18.0))
                
                Text(store.description)
                    .font(.maruburiot(type: .semiBold, size: 17))
                
                Text(store.dateDescription)
                    .font(.maruburiot(type: .regular, size: 16))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .foregroundStyle(Color(uiColor: .white))
        }
        .padding(20)
        .frame(height: size.height / 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBackground)
    }
}

struct HangdamStatusStore {
    let image: Image
    let name: String
    let description: String
    let dateDescription: String
    
    var hasName: Bool {
        name != "이름을 지어주세요!"
    }
}

#Preview {
    Group {
        HangdamStatusView(
            size: CGSize(width: 402, height: 716),
            store: .constant(
                HangdamStatusStore(
                    image: .hangdamImage(level: 1),
                    name: "a name",
                    description: "a description",
                    dateDescription: "a date description"
                )
            )
        )
        
        HangdamStatusView(
            size: CGSize(width: 402, height: 716),
            store: .constant(
                HangdamStatusStore(
                    image: .hangdamImage(level: 1),
                    name: "a name",
                    description: "a description",
                    dateDescription: ""
                )
            )
        )
    }
}
