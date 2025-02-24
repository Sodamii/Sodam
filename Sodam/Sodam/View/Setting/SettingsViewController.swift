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
    // 필요시 사용을 위해 lazy 사용
    private lazy var alertManager: AlertManager = AlertManager(viewController: self)

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
        setupObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupCheckNotification()
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    deinit {
        removeObservers()
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
        settingView.tableView.sectionFooterHeight = 0
        
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
    }

    // NotificationCenter Observer Set
    func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkNotificationStatus),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateFont), name: Notification.fontChanged, object: nil)
    }

    // NotificationCenter Remove
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self)
    }

    // Check Notification Set
    func setupCheckNotification() {
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
    
    // MARK: - Font Change
    @objc private func updateFont() {
        settingView.tableView.reloadData()
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
        case .fontSetting:
            return 1
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
                               timeAction: nil,
                               version: "")
                cell.switchButton.isOn = settingViewModel.isToggleOn

            } else if indexPath.row == 1 {
                // 두 번째 셀: 시간 설정 (스위치가 켜졌을 때만 표시)
                cell.timePicker.isHidden = false
                cell.switchButton.isHidden = true
                cell.configure(title: Setting.SetCell.setTime.rawValue,
                               switchAction: nil,
                               timeAction: #selector(userScheduleNotification),
                               version: "")

                let savedTime = settingViewModel.getNotificationTime()
                cell.timePicker.date = savedTime
            }
            
        case .fontSetting:
            cell.arrowImage.isHidden = false
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = true
            cell.versionLabel.isHidden = true
            
            cell.configure(title: Setting.SetCell.fontSetting.rawValue,
                           switchAction: nil,
                           timeAction: nil,
                           version: "")

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
        
        // 폰트 적용
        cell.updateFont()
        
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
            
        case .fontSetting:
            let fontSettingViewModel = FontSettingViewModel()
            let fontSettingVC = FontSettingViewController(fontSettingViewModel: fontSettingViewModel) // 생성자 주입
            fontSettingVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(fontSettingVC, animated: true)
            
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
                if status {
                    self.updateNotificationState(isEnabled: toggleState)
                } else {
                    sender.setOn(false, animated: true)
                    self.settingViewModel.saveAppToggleState(false)
                    self.alertManager.showNotificationPermissionAlert()
                }
                self.updateToggleState()
            }
        }
    }
    
    private func updateNotificationState(isEnabled: Bool) {
        settingViewModel.isToggleOn = isEnabled
        settingViewModel.saveAppToggleState(isEnabled)
        
        if isEnabled {
            settingViewModel.setUserNotification()
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    // 사용자가 DatePicker를 통해 알림 시간을 선택했을 때 호출되는 액션
    @objc func userScheduleNotification(_ sender: UIDatePicker) {
        // 선택한 시간을 뷰모델에 저장하고, 알림 스위치가 켜진 경우 알림 예약을 업데이트
        settingViewModel.saveNotificationTime(sender.date)
        
        if settingViewModel.isToggleOn {
            settingViewModel.setUserNotification()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SettingsViewController(settingViewModel: SettingViewModel())
}
