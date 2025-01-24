//
//  SettingsViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let settingViewModel: SettingViewModel

    let settingView = SettingView()

    init(settingViewModel: SettingViewModel) {
        self.settingViewModel = settingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .viewBackground
        setupTableView()
        setupScheduledNotification()
    }
}

// MARK: - Private Method

private extension SettingsViewController {
    func setupTableView() {
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        settingView.tableView.separatorInset.right = 15
        
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
    }
    
    func setupScheduledNotification() {
        // UserDefaults에서 알림 상태 복원
        settingViewModel.isSwitchOn =
        settingViewModel.getIsToggle()
        if settingViewModel.isSwitchOn {
            if let savedTime = settingViewModel.getNotificationTime() {
                settingViewModel.setReservedNotificaion(savedTime)
            }
        }
    }
}

// MARK: - UITableView Method

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingViewModel.sectionType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = settingViewModel.sectionType[safe: section] else {
            return 0
        }
        
        switch sectionType {
        case .appSetting:
            return settingViewModel.isSwitchOn ? 2 : 1
        case .develop:
            return 2
        }
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = settingViewModel.sectionType[safe: indexPath.section],
              let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
        // 셀 구성
        switch sectionType {
        case .appSetting:
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = false
            cell.arrowImage.isHidden = true
            cell.versionLabel.isHidden = true
            
            if indexPath.row == 0 {
                // 첫 번째 셀: 알림 설정
                cell.configure(title: Setting.SetCell.notification.rawValue, switchAction: #selector(didToggleSwitch(_:)), timeAction: nil, version: "")
                cell.switchButton.isOn = settingViewModel.isSwitchOn
            } else if indexPath.row == 1 && settingViewModel.isSwitchOn {
                // 두 번째 셀: 시간 설정 (스위치가 켜졌을 때만 표시)
                cell.configure(title: Setting.SetCell.setTime.rawValue, switchAction: nil, timeAction: #selector(userScheduleNotification), version: "")
                cell.titleLabel.textColor = .black
                cell.timePicker.isHidden = false
                cell.switchButton.isHidden = true
            }
            
        case .develop:
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = true

            // 두 번째 섹션의 셀 (항상 두 개 표시)
            if indexPath.row == 0 {
                cell.versionLabel.isHidden = true
                cell.arrowImage.isHidden = false

                cell.configure(title: Setting.SetCell.appReview.rawValue, switchAction: nil, timeAction: nil, version: "")
            } else if indexPath.row == 1 {
                cell.versionLabel.isHidden = false
                cell.arrowImage.isHidden = true
                cell.configure(title: "\(Setting.SetCell.appVersion.rawValue)", switchAction: nil, timeAction: nil, version: settingViewModel.version ?? "")
            }
        }
        return cell
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
        settingViewModel.isSwitchOn = sender.isOn

        settingViewModel.saveIsToggleNotification(settingViewModel.isSwitchOn)
        // 알림 예약 또는 취소 처리
        if let savedTime = settingViewModel.getNotificationTime(), settingViewModel.isSwitchOn {
            // 저장된 알림 시간과 스위치 상태가 켜져 있을 경우
            settingViewModel.setReservedNotificaion(savedTime)
        } else {
            // 스위치가 꺼져 있을 경우 기존 알림시간 삭제
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SelectedTimeNotification"])
        }
        settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    // 사용자가 선택한 알림 시간 UserDefaultsManager에 저장
    @objc func userScheduleNotification(_ sender: UIDatePicker) {
        settingViewModel.saveNotificationTime(sender.date)  // Date객체를 그대로 UserDefaultsManager 저장(현지시간으로는 안보임)
        // 새로 선택된 시간에 맞춰 알림을 예약하는 코드가 필요하여 작성
        if settingViewModel.isSwitchOn {
            settingViewModel.setReservedNotificaion(sender.date)
        }
    }
}
