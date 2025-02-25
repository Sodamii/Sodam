//
//  HangdamStatusView.swift
//  Sodam
//
//  Created by EMILY on 21/01/2025.
//

import SwiftUI

struct HangdamStatusView: View {

    let size: CGSize

    @ObservedObject var viewModel: HangdamStatusViewModel
    @Binding var isCurrentHangdam: Bool
    
    @State private var renameAlertPresented: Bool = false
    @State private var textInput: String = ""

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Image
                .hangdamImage(level: viewModel.statusContent.level)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width / 3)
                .background(Color.imageBackground)
                .clipShape(.circle)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center) {
                    Text(viewModel.statusContent.name)
                        .appFont(size: .title2)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)
                    
                    if isCurrentHangdam {   // 기록 탭에서만 행담이 이름 옆에 수정 버튼
                        Button {
                            textInput = viewModel.statusContent.nameText
                            renameAlertPresented = true
                        } label: {
                            Image(systemName: "pencil")
                                .font(.title3)
                                .bold()
                        }
                    }
                }

                Text(viewModel.statusContent.levelDescription)
                    .appFont(size: .body1)

                Text(viewModel.statusContent.dateDescription)
                    .appFont(size: .body2)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .foregroundStyle(Color(uiColor: .white))
        }
        .padding(20)
        .frame(height: size.height / 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.tabBackground)
        .alert(isPresented: $renameAlertPresented) {
            Alert(title: Text(""))
        }
        .background(
            AlertControllerWrapper(
                alertPresented: $renameAlertPresented,
                textInput: $textInput,
                alertCase: .renameHangdam,
                onConfirm: {
                    viewModel.renameHangdam(textInput)
                }
            )
        )
    }
}

#Preview {
    HangdamStatusView(
        size: CGSize(width: 402, height: 716),
        viewModel: HangdamStatusViewModel(statusContent: StatusContent(
            id: "",
            level: 1,
            name: "test",
            levelDescription: "lv.1 test",
            dateDescription: "2000.22.22 ~"
        ), statusViewOperator: StatusViewOperator(hangdamRepository: HangdamRepository())),
        isCurrentHangdam: .constant(true)
    )
}
