//
//  SettingTableViewCell.swift
//  Sodam
//
//  Created by t2023-m0019 on 1/21/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell, ReuseIdentifying {
    let baseView = UIView()
    private let setTitle: UILabel = {
        let label = UILabel()
        label.font = .mapoGoldenPier(14)
        label.textColor = .darkGray
        return label
    }()
    
    let horizonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    let switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.isOn = false
        switchButton.onTintColor = .buttonBackground
        return switchButton
    }()
    
    let arrowImage: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "chevron.right")
        arrowImage.tintColor = .buttonBackground
        return arrowImage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, switchAction: Selector?) {
        setTitle.text = title
        if let action = switchAction {
            switchButton.addTarget(nil, action: action, for: .valueChanged) // nil을 self로 변경
        }
    }
}

// MARK: - Private Method

private extension SettingTableViewCell {
    func setupUI() {
        baseView.backgroundColor = .imageBackground
        contentView.addSubview(baseView)
        baseView.addSubViews([setTitle, horizonStackView])
        horizonStackView.addArrangedSubViews([switchButton, arrowImage])
    }
    
    func setupConstraint() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalTo(baseView.snp.centerY)
        }
        
        horizonStackView.snp.makeConstraints {
            $0.leading.equalTo(setTitle.snp.trailing)
            $0.trailing.equalTo(baseView.snp.trailing).offset(-20)
            $0.centerY.equalTo(setTitle.snp.centerY)
        }
    }
}
