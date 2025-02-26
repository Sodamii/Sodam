//
//  HangdamStatusViewModel.swift
//  Sodam
//
//  Created by EMILY on 25/02/2025.
//

import SwiftUI

final class HangdamStatusViewModel: ObservableObject {
    
    @Published var statusContent: StatusContent
    
    private let statusViewOperator: StatusViewOperator
    
    init(statusContent: StatusContent, statusViewOperator: StatusViewOperator) {
        self.statusContent = statusContent
        self.statusViewOperator = statusViewOperator
    }
    
    func renameHangdam(_ text: String) {
        let newName = "\(text)담이"
        statusViewOperator.renameHangdam(id: statusContent.id, newName: newName)
        NotificationCenter.default.post(name: Notification.hangdamRenamed, object: nil)
    }
}
