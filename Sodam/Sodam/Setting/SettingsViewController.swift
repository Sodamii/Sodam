//
//  SettingsViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let settingViewModel: SettingViewModel

    private let settingView = SettingView()

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
        // UserDefaults에서 알림 상태 복원 (이미 뷰모델에서 초기화했으므로 중복 처리 없음)
        if settingViewModel.isSwitchOn {
            if let savedTime = settingViewModel.getNotificationTime() {
                print("savedTime \(savedTime)")
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
                
                // 저장된 시간이 있으면 설정
                if let savedTime = settingViewModel.getNotificationTime() {
                    print("savedTimeCell \(savedTime)")
                    cell.timePicker.date = savedTime
                }
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
    
    // 셀이 선택되었을 때 동작 처리
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionType = settingViewModel.sectionType[safe: indexPath.section] else { return }
        switch sectionType {
        case .develop:
            if indexPath.row == 0 {
                // TODO: - 리뷰 남기기 링크로 변경 필요
                settingViewModel.openURL("https://www.naver.com")
            }
        default:
            break
        }
    }
    
    @objc func didToggleSwitch(_ sender: UISwitch) {
        settingViewModel.isSwitchOn = sender.isOn
        settingViewModel.saveIsToggleNotification(sender.isOn)
        
        if sender.isOn {
            if let savedTime = settingViewModel.getNotificationTime() {
                settingViewModel.setReservedNotificaion(savedTime)
            } else {
                // 저장된 시간이 없는 경우 현재 시간을 기본값으로 저장
                let currentDate = Date()
                settingViewModel.saveNotificationTime(currentDate)
                settingViewModel.setReservedNotificaion(currentDate)
            }
        } else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SelectedTimeNotification"])
        }
        
        settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    // 사용자가 선택한 알림 시간 UserDefaultsManager에 저장
    @objc func userScheduleNotification(_ sender: UIDatePicker) {
        settingViewModel.saveNotificationTime(sender.date)
        print("sender.date11 \(sender.date)")

        if settingViewModel.isSwitchOn {
            settingViewModel.setReservedNotificaion(sender.date)
            print("sender.date22 \(sender.date)")

        }
    }
}
