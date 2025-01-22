//
//  SettingsViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class SettingsViewController: UIViewController {
    var isSwitchOn: Bool = false
    let sectionType: [Setting.SetSection] = [.appSetting, .develop]
    var cellType: [Setting.SetSection: [Setting.SetCell]] = [
        .appSetting: [.notification], // 초기 상태에서 기본값 설정
        .develop: [.appReview, .appVersion]
    ]

    let settingView = SettingView()

    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackground
        setTableView()
    }
}

// MARK: - Private Method

private extension SettingsViewController {
    func setTableView() {
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        settingView.tableView.separatorInset.right = 15
        
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
    }
}

// MARK: - UITableView Method

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = sectionType[safe: section] else {
            return 0
        }
        
        switch sectionType {
        case .appSetting:
            return isSwitchOn ? 2 : 1
        case .develop:
            return 2
        }
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // 섹션 간 간격
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = sectionType[safe: indexPath.section],
              let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        // 셀 구성
        switch sectionType {
        case .appSetting:
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = false
            cell.arrowImage.isHidden = true
            
            if indexPath.row == 0 {
                // 첫 번째 셀: 알림 설정
                cell.configure(title: Setting.SetCell.notification.rawValue, switchAction: #selector(didToggleSwitch(_:)))
                cell.switchButton.isOn = isSwitchOn
            } else if indexPath.row == 1 && isSwitchOn {
                // 두 번째 셀: 시간 설정 (스위치가 켜졌을 때만 표시)
                cell.configure(title: Setting.SetCell.setTime.rawValue, switchAction: nil)
                cell.timePicker.isHidden = false
                cell.switchButton.isHidden = true
            }
            
        case .develop:
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = true
            cell.arrowImage.isHidden = false

            // 두 번째 섹션의 셀 (항상 두 개 표시)
            if indexPath.row == 0 {
                cell.configure(title: Setting.SetCell.appReview.rawValue, switchAction: nil)
            } else if indexPath.row == 1 {
                cell.configure(title: "\(Setting.SetCell.appVersion.rawValue): 1.0.0", switchAction: nil)
            }
        }
        return cell
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
        isSwitchOn = sender.isOn
        print("isSwitchOn \(isSwitchOn)")
        settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
