//
//  SettingTableViewCell.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit
import SnapKit

final class SettingTableViewCell: UITableViewCell, ReuseIdentifying {
    let baseView = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .mapoGoldenPier(16)
        label.textColor = .darkGray
        return label
    }()
    
    let horizonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .trailing
        stackView.spacing = 0
        return stackView
    }()
    
    let timePicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .compact
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "ko")
        timePicker.minuteInterval = 1
        timePicker.tintColor = .buttonBackground
        return timePicker
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
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.font = .mapoGoldenPier(16)
        label.textColor = .darkGray
        return label
    }()
    
    private var currentSwitchAction: Selector?
    private var currentTimeAction: Selector?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀 재사용 시 타겟 액션 제거(메모리 누수 방지)
        switchButton.removeTarget(nil, action: nil, for: .valueChanged)
        timePicker.removeTarget(nil, action: nil, for: .valueChanged)
        
        currentSwitchAction = nil
        currentTimeAction = nil
    }
    
    func configure(title: String, switchAction: Selector?, timeAction: Selector?, version: String) {
        titleLabel.text = title
        versionLabel.text = version
        if let action = switchAction {
            switchButton.addTarget(nil, action: action, for: .valueChanged)
        }
        if let action = timeAction {
            timePicker.addTarget(nil, action: action, for: .valueChanged)
        }
    }
}

// MARK: - Private Method

private extension SettingTableViewCell {
    func setupUI() {
        baseView.backgroundColor = .imageBackground
        contentView.addSubview(baseView)
        baseView.addSubViews([titleLabel, horizonStackView])
        horizonStackView.addArrangedSubViews([timePicker, switchButton, arrowImage, versionLabel])
    }
    
    func setupConstraint() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.equalToSuperview().offset(20)
        }
        
        horizonStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(baseView.snp.trailing).offset(-20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}
