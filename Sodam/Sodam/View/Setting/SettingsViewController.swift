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
        // 사용자 설정 화면에 진입할 때 뱃지 초기화
        UIApplication.shared.applicationIconBadgeNumber = 0
        // 앱이 포그라운드로 돌아올 때마다 알림 권한 상태를 재확인하여 UI(스위치 상태)를 업데이트
        NotificationCenter.default.addObserver(self, selector: #selector(checkNotificationPermissionAndUpdateSwitch), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    // 뷰 컨트롤러가 소멸되기 전에 옵저버를 제거
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 알림 권한 상태를 체크하여 스위치의 초기 상태를 업데이트
        checkNotificationPermissionAndUpdateSwitch()
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
    
    /// 현재 알림 권한 상태를 확인한 후, 해당 상태에 따라 스위치와 알림 시간을 업데이트
    ///
    /// - 설명:
    ///   1. `UNUserNotificationCenter`의 설정을 가져와 사용자가 알림을 허용했는지 확인
    ///   2. 허용된 경우 스위치를 ON 상태로 만들고, 저장된 알림 시간이 없으면 기본 시간(21:00)으로 설정
    ///   3. 거부된 경우 스위치를 OFF 상태로 유지하고, 상태를 저장
    @objc func checkNotificationPermissionAndUpdateSwitch() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                //_ = !self.settingViewModel.isToggleOn
                let isAuthorizedNow = settings.authorizationStatus == .authorized  // 현재 알림 권한이 허용된 상태인지 확인
                
                if isAuthorizedNow {
                    // 사용자가 설정에서 알림을 허용했을 경우
                    self.settingViewModel.isToggleOn = true
                    self.settingViewModel.saveIsToggleNotification(true)
                    
                    if self.settingViewModel.getNotificationTime() == nil {
                        // 기존에 저장된 알림 시간이 없으면 기본값(21:00) 설정
                        let defaultTime = self.defaultNotificationTime()
                        self.settingViewModel.saveNotificationTime(defaultTime)
                        self.settingViewModel.setReservedNotificaion(defaultTime)
                    }
                } else {
                    // 알림 권한이 거부된 경우 스위치를 OFF로 설정
                    self.settingViewModel.isToggleOn = false
                    self.settingViewModel.saveIsToggleNotification(false)
                }
                
                // 변경된 상태를 반영하기 위해 테이블뷰의 첫 번째 섹션을 다시 로드
                self.settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    // 기본 시간(21:00) 반환하는 함수
    private func defaultNotificationTime() -> Date {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
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
            cell.timePicker.isHidden = true
            cell.switchButton.isHidden = false
            cell.arrowImage.isHidden = true
            cell.versionLabel.isHidden = true
            
            if indexPath.row == 0 {
                // 첫 번째 셀: 알림 설정
                cell.configure(title: Setting.SetCell.notification.rawValue, switchAction: #selector(didToggleSwitch(_:)), timeAction: nil, version: "")
                cell.switchButton.isOn = settingViewModel.isToggleOn
            } else if indexPath.row == 1 && settingViewModel.isToggleOn {
                // 두 번째 셀: 시간 설정 (스위치가 켜졌을 때만 표시)
                cell.configure(title: Setting.SetCell.setTime.rawValue, switchAction: nil, timeAction: #selector(userScheduleNotification), version: "")
                cell.titleLabel.textColor = .black
                cell.timePicker.isHidden = false
                cell.switchButton.isHidden = true
                
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
                settingViewModel.openURL("https://apps.apple.com/us/app/sodam/id6741320265")
            }
        default:
            break
        }
    }
    
    // 알림 스위치의 상태가 변경되었을 때 호출되는 액션
    @objc func didToggleSwitch(_ sender: UISwitch) {
        // 알림 권한 상태를 비동기로 확인하여, 권한이 없는 경우 경고창을 띄우고 스위치를 OFF로 변경
        // TODO: UserDefatulsManager로 변경 필요
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    // 알림 권한이 없는 경우 스위치를 OFF 상태로 되돌리고, 권한 요청 안내 알럿 띄움
                    sender.isOn = false // 토글을 다시 OFF 상태로 변경
                    self.showNotificationPermissionAlert()
                } else {
                    // 권한이 허용된 경우, 토글 상태에 따라 알림 예약/해제 로직을 수행
                    self.handleNotificationToggle(isOn: sender.isOn)
                }
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
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            // 해당 앱 설정으로 이동
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        // 메인 스레드에서 표시
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 알림 스위치가 On/Off시 실행되는 메서드
    private func handleNotificationToggle(isOn: Bool) {
        // 뷰모델의 상태를 업데이트하고 UserDefaults에 저장
        settingViewModel.isToggleOn = isOn
        settingViewModel.saveIsToggleNotification(isOn)
        
        if isOn {
            // 알림 스위치가 켜진 경우, 저장된 알림 시간이 있으면 해당 시간으로 알림 예약을 진행
            if let savedTime = settingViewModel.getNotificationTime() {
                settingViewModel.setReservedNotificaion(savedTime)
            } else {
                // 저장된 시간이 없는 경우 현재 시간을 기본값으로 사용하여 알림 예약
                // TODO: 현재시간이 아닌 디폴트 9시 재확인
                let currentDate = Date()
                settingViewModel.saveNotificationTime(currentDate)
                settingViewModel.setReservedNotificaion(currentDate)
            }
        } else {
            // 알림 스위치가 꺼진 경우, 미리 예약된 알림 요청을 제거
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["SelectedTimeNotification"])
        }
        
        // 알림 스위치 상태 변경에 따른 UI 갱신을 위해 첫 번째 섹션을 다시 로드
        settingView.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
