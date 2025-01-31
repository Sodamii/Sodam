//
//  SettingView.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit
import SnapKit

final class SettingView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method

private extension SettingView {
    func setUI() {
        self.backgroundColor = .clear
        tableView.backgroundColor = .clear
        addSubview(tableView)
    }
    
    func setConstraint() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
