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
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObservers()
        setupChekNotification()
    }

    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        self.settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}

// MARK: - Private Setup Method

private extension SettingsViewController {
    // UI Set
    func setupUI() {
        view.backgroundColor = .viewBackground
        setupTableView()
    }

    // TableView Set
    func setupTableView() {
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        settingView.tableView.separatorInset.right = 15
        
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
    }

    // BadgeNumber Init
    func initBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0  // 사용자 설정 화면에 진입할 때 뱃지 초기화
    }

    // NotificationCenter Observer Set
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkNotificationStatus),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    // NotificationCenter Remove
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
    }

    // Check Notification Set
        func setupChekNotification() {
            UIApplication.shared.applicationIconBadgeNumber = 0  // 사용자 설정 화면에 진입할 때 뱃지 초기화
            checkNotificationStatus()  // 뷰가 나타날 때마다 현재 알림 권한 상태를 체크하고 UI 업데이트
        }

    // NotificationStatus Check
    @objc func checkNotificationStatus() {
        settingViewModel.checkNotificationStatus { [weak self] isAuthorized in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // 현재 시스템 설정이 꺼져있으면 앱 토글도 강제로 꺼짐
                if !isAuthorized {
                    self.settingViewModel.isToggleOn = isAuthorized
                    self.settingViewModel.saveAppToggleState(false)
                }
                self.updateToggleState()
            }
        }
    }

    func updateToggleState() {
        settingViewModel.isToggleOn = settingViewModel.getToggleState()
        settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
            return 3
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

            } else if indexPath.row == 1 {
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
                cell.versionLabel.isHidden = true
                cell.arrowImage.isHidden = false
                cell.configure(title: "\(Setting.SetCell.feedback.rawValue)",
                               switchAction: nil,
                               timeAction: nil,
                               version: "")
            } else if indexPath.row == 2 {
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
            } else if indexPath.row == 1 {
                settingViewModel.openURL("https://forms.gle/GKAfcPZL9cenQxx78")
            }
        default:
            break
        }
    }

    // 알림 스위치의 상태가 변경되었을 때 호출되는 액션
    @objc func didToggleSwitch(_ sender: UISwitch) {
        let toggleState = sender.isOn
        settingViewModel.checkNotificationStatus { [weak self] status in
            guard let self = self else { return }
            DispatchQueue.main.async {
                // 시스템 설정 확인 후 허용시,
                if status {
                    if toggleState {
                        // 알림이 허용되고 스위치가 ON이면 사용자 토글 상태 저장
                        self.settingViewModel.isToggleOn = toggleState
                        self.settingViewModel.saveAppToggleState(toggleState)
                        
                        // 알림 예약을 다시 설정 (스위치가 켜졌을 때만)
                        if let notificationTime = self.settingViewModel.getNotificationTime() {
                            self.settingViewModel.setReservedNotificaion(notificationTime)
                        }
                        
                    } else {
                        // 알림이 허용되고 스위치가 OFF이면 알림 삭제
                        self.settingViewModel.isToggleOn = toggleState
                        self.settingViewModel.saveAppToggleState(toggleState)
                        
                        // 알림을 취소
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    }

                // 시스템 설정 확인 후 거부시, 설정으로 이동 알럿
                } else {
                    sender.setOn(false, animated: true)
                    self.settingViewModel.saveAppToggleState(false)
                    self.settingViewModel.showNotificationPermissionAlert(viewController: self)
                }
                self.updateToggleState()
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
}

@available(iOS 17.0, *)
#Preview {
    SettingsViewController(settingViewModel: SettingViewModel())
}
