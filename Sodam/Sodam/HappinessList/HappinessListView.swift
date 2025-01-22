//
//  HappinessView.swift
//  Sodam
//
//  Created by 박진홍 on 1/21/25.
//

import SwiftUI

struct HappinessListView: View {
    
    let array: [Int] = [12,123,1123]
    
    var body: some View {
        Text("행담이가 먹고 자란 기억들")
            .font(.mapoGoldenPier(20))
        List {
            ForEach(array, id: \.self) { value in
                HStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 90, height: 120)
                    VStack {
                        Text("Horror House")
                            .multilineTextAlignment(.leading)
                        Text("Merong merong")
                        Text("1102.1230.123")
                    }
                    Spacer(minLength: 80)
                }
            }
        }
        
    }
}

#Preview {
    HappinessListView()
}


