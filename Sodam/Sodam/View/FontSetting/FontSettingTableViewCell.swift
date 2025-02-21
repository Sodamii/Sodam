//
//  FontSettingTableViewCell.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit
import SnapKit

final class FontSettingTableViewCell: UITableViewCell, ReuseIdentifying {
    var baseView = UIView()
    
    let backgroundColorView: UIView = {
        let background = UIView()
        return background
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let checkImage: UIImageView = {
        let arrowImage = UIImageView()
        arrowImage.image = UIImage(systemName: "checkmark.circle.fill")
        return arrowImage
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()

    var didTapFontCellHandler: (() -> Void)?
    var indexPath: IndexPath?
    private var isSelectedCell = false // 셀의 선택 여부 추적
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupUI()
        setupConstraint()
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(customFont: CustomFont, isSelected: Bool) {
        titleLabel.font = UIFont(name: customFont.sourceName, size: CustomFontSize.body1.rawValue)
        titleLabel.text = customFont.name
        setButton(isSelected: isSelected)
    }

    @objc private func didTapButton() {
        guard indexPath != nil else {
            return
        }
        didTapFontCellHandler?()
    }

    func setButton(isSelected: Bool) {
//        if isSelected {
//            titleLabel.textColor = .imageBackground
//            checkImage.tintColor = .imageBackground
//            backgroundColorView.backgroundColor = .tabBackground
//        } else {
//            titleLabel.textColor = .darkGray
//            checkImage.tintColor = .viewBackground
//            backgroundColorView.backgroundColor = .imageBackground
//        }
        if isSelected {
            titleLabel.textColor = .darkGray
            checkImage.tintColor = .tabBackground
            backgroundColorView.backgroundColor = .imageBackground
        } else {
            titleLabel.textColor = .darkGray
            checkImage.tintColor = .viewBackground
            backgroundColorView.backgroundColor = .imageBackground
        }
    }

    // 셀을 선택 해제할 때 상태 초기화
    func deselectCell() {
        isSelectedCell = false
        setButton(isSelected: false)
    }
}

// MARK: - Private Method

private extension FontSettingTableViewCell {
    func setupUI() {
        baseView.backgroundColor = .clear
        contentView.addSubview(baseView)
        baseView.addSubViews([backgroundColorView, titleLabel, checkImage, button])
    }

    func setupConstraint() {
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundColorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        checkImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }

        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
