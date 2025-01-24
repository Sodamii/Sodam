//
//  TestView.swift
//  Sodam
//
//  Created by EMILY on 24/01/2025.
//

import SwiftUI

struct TestView: View {
    
    @Binding var hangdam: MockHangdam
    
    var body: some View {
        VStack {
            Text("\(hangdam.name)가 담은 기억들")
            ForEach(hangdam.happiness) { happiness in
                Text(happiness.content)
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.viewBackground)
    }
}

#Preview {
    TestView(hangdam: .constant(.mockHangdam))
}
