//
//  SettingsViewController.swift
//  Sodam
//
//  Created by 박시연 on 1/21/25.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let settingViewModel: SettingViewModel
    private let settingView = SettingView()
    
    // MARK: - Initializer
    
    init(settingViewModel: SettingViewModel) {
        self.settingViewModel = settingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // 스토리보드 등에서 사용되지 않으므로, 해당 초기화는 구현하지 않음
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkNotificationAuthorizationStatus),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.applicationIconBadgeNumber = 0  // 사용자 설정 화면에 진입할 때 뱃지 초기화
        checkNotificationAuthorizationStatus()  // 뷰가 나타날 때마다 현재 알림 권한 상태를 체크하고 UI 업데이트
        settingView.tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        self.settingViewModel.isToggleOn = settingViewModel.getAppNotificationToggleState()
    }
    
    // 알림 권한 상태를 확인하는 메서드 추가
    @objc func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let isAuthorized = settings.authorizationStatus == .authorized
                self.settingViewModel.saveNotificationAuthorizationStatus(isAuthorized)
                
                if isAuthorized {
                    if self.settingViewModel.isToggleOn {
                        self.settingViewModel.saveIsAppToggleNotification(true)
                        self.settingViewModel.isToggleOn = true
                    } else {
                        self.settingViewModel.saveIsAppToggleNotification(false)
                        self.settingViewModel.isToggleOn = false
                    }
                    
                } else {
                    self.settingViewModel.saveIsAppToggleNotification(false)
                    self.settingViewModel.isToggleOn = false
                }
                
                self.settingView.tableView.reloadData()
            }
        }
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
            return settingViewModel.isToggleOn ? 2 : 1
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
            cell.arrowImage.isHidden = true
            cell.versionLabel.isHidden = true
            
            if indexPath.row == 0 {
                // 첫 번째 셀: 알림 설정
                cell.timePicker.isHidden = true
                cell.switchButton.isHidden = false
                cell.configure(title: Setting.SetCell.notification.rawValue,
                               switchAction: #selector(didToggleSwitch(_:)),
                               timeAction: nil, version: "")
                cell.switchButton.isOn = settingViewModel.isToggleOn
                
            } else if indexPath.row == 1 && settingViewModel.getAppNotificationToggleState() {
                // 두 번째 셀: 시간 설정 (스위치가 켜졌을 때만 표시)
                cell.timePicker.isHidden = false
                cell.switchButton.isHidden = true
                cell.configure(title: Setting.SetCell.setTime.rawValue,
                               switchAction: nil,
                               timeAction: #selector(userScheduleNotification),
                               version: "")
                
                if let savedTime = settingViewModel.getNotificationTime() {
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
                cell.configure(title: Setting.SetCell.appReview.rawValue,
                               switchAction: nil,
                               timeAction: nil,
                               version: "")
            } else if indexPath.row == 1 {
                cell.versionLabel.isHidden = false
                cell.arrowImage.isHidden = true
                cell.configure(title: "\(Setting.SetCell.appVersion.rawValue)",
                               switchAction: nil,
                               timeAction: nil,
                               version: settingViewModel.version ?? "")
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
                settingViewModel.openURL("https://apps.apple.com/us/app/sodam/id6741320265")
            }
        default:
            break
        }
    }
    
    // 알림 스위치의 상태가 변경되었을 때 호출되는 액션
    @objc func didToggleSwitch(_ sender: UISwitch) {
        let newState = sender.isOn
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if settings.authorizationStatus == .authorized {
                    // 알림이 허용된 상태면 저장 및 UI 업데이트
                    self.settingViewModel.saveIsAppToggleNotification(newState)
                    self.settingViewModel.isToggleOn = newState
                } else {
                    // 알림이 거부된 상태에서는 강제로 스위치를 OFF 하고, 상태 저장 X
                    sender.setOn(false, animated: true)
                    
                    // 상태를 저장하지 않고, 사용자가 설정을 변경할 수 있도록 안내
                    self.showNotificationPermissionAlert()
                }
                
                self.settingView.tableView.reloadData()
            }
        }
    }
    
    // 사용자가 DatePicker를 통해 알림 시간을 선택했을 때 호출되는 액션
    @objc func userScheduleNotification(_ sender: UIDatePicker) {
        //선택한 시간을 뷰모델에 저장하고, 알림 스위치가 켜진 경우 알림 예약을 업데이트
        settingViewModel.saveNotificationTime(sender.date)
        
        if settingViewModel.isToggleOn {
            settingViewModel.setReservedNotificaion(sender.date)
        }
    }
    
    // 알림 권한이 없는 경우 사용자에게 알림 권한 설정을 요청하는 알럿띄움 함수
    private func showNotificationPermissionAlert() {
        let alertController = UIAlertController(
            title: "알림 권한 필요",
            message: "앱의 알림을 받으려면 설정에서 알림을 허용해주세요.",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] _ in
            self?.settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
        
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { [weak self] _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { _ in
                    // 설정에서 돌아올 때 상태 업데이트
                    self?.checkNotificationAuthorizationStatus()
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    SettingsViewController(settingViewModel: SettingViewModel())
}
