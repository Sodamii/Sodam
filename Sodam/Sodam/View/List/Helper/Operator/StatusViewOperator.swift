//
//  StatusViewOperator.swift
//  Sodam
//
//  Created by EMILY on 25/02/2025.
//

import Foundation

protocol HangdamRenaming {
    func renameHangdam(id: String, newName: String)
}

final class StatusViewOperator: HangdamRenaming {
    private let hangdamRepository: HangdamRepository
    
    init(hangdamRepository: HangdamRepository) {
        self.hangdamRepository = hangdamRepository
    }
    
    func renameHangdam(id: String, newName: String) {
        hangdamRepository.nameHangdam(id: id, name: newName)
    }
}
