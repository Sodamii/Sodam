//
//  HangdamStatusView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStatusView: View {
    
    let size: CGSize
    
    @Binding var hangdam: HangdamDTO
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image(.kingdam2)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width / 3)
                .background(Color.imageBackground)
                .clipShape(.circle)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(hangdam.name ?? "이름을 지어주세요!")
                    .font(.maruburiot(type: .bold, size: 25))
                Text("Lv.\(hangdam.level) 애기 행담이")
                    .font(.maruburiot(type: .semiBold, size: 18))
                if let startDate = hangdam.startDate {
                    Text("\(startDate) ~")
                        .font(.maruburiot(type: .regular, size: 16))
                } else {
                    Text("")
                }
                
            }
            .foregroundStyle(Color(uiColor: .white))
        }
        .padding(16)
        .frame(height: size.height / 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBackground)
    }
}

#Preview {
    let hangdamRepository: HangdamRepository = HangdamRepository()
    HangdamStatusView(size: CGSize(width: 402, height: 716), hangdam: .constant(hangdamRepository.getCurrentHangdam()))
}
