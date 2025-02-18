//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit
import Combine

/// MainView와 MainViewModel을 연결하여 화면을 제어하는 ViewController
final class MainViewController: UIViewController {

    // MARK: - Properties

    private let mainView: MainView = MainView()
    private let viewModel: MainViewModel
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()

    // 알럿이 항상 필요한게 아니라서 필요할때까지 초기화를 지연시키려고 lazy 사용
    private lazy var alertManager: AlertManager = AlertManager(viewController: self)

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.viewModel = MainViewModel(repository: HangdamRepository())
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle Methods

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()            // viewModel과 view를 바인딩
        configureButtonAction()    // 작성 버튼 액션 설정
        addGesture()               // 이미지 탭 제스처 설정

        // 작성 완료 알림 감지하여 버튼 상태 갱신
        NotificationCenter.default.addObserver(self, selector: #selector(didWriteToday), name: Notification.didWriteToday, object: nil)
    }

    /// 뷰가 다시 나타날 때 데이터 갱신
    override func viewWillAppear (_ animated: Bool) {
        viewModel.reloadHangdam() // ViewModel에서 행담이 데이터를 갱신
        updateButtonState()       // 화면이 다시 나타날 때 버튼 상태 갱신
        LocalNotificationManager.shared.checkInitialSetup()  // 앱 첫 진입시 알림 권한 팝업 설정
    }

    // MARK: - bind view model for update view

    /// ViewModel과 View를 바인딩 해서 데이터 변화를 UI에 반영함.
    private func bindViewModel() {
        viewModel.$hangdam
            .receive(on: RunLoop.main)
            .sink { [weak self] hangdam in
                self?.mainView.updateNameLabel(hangdam.name) // 이름 설정
                self?.mainView.updateGif(with: "phase\(hangdam.level)") // 레벨에 따른 GIF 업데이트
            }
            .store(in: &cancellables)

        // 메세지 데이터 변경 시 UI 업데이트
        viewModel.$message
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.mainView.updateMessage(message)
            }
            .store(in: &cancellables)
    }

    /// 버튼 상태 갱신 메서드 추가
    private func updateButtonState() {
        let hasWritten = viewModel.hasAlreadyWrittenToday()
        mainView.createbutton.isEnabled = true
        mainView.createbutton.alpha = hasWritten ? 0.5 : 1.0
    }

    /// 오늘 작성이 완료되었을 때 호출되는 메서드
    @objc private func didWriteToday() {
        viewModel.markAsWrittenToday()
        updateButtonState()
    }

    // MARK: - setup button action

    /// 작성 버튼 클릭 시 액션 설정
    private func configureButtonAction() {
        mainView.createbutton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }

    /// 이미지 뷰 탭할 때 액션 설정
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        mainView.circularImageView.addGestureRecognizer(tapGesture)
        mainView.circularImageView.isUserInteractionEnabled = true
    }

    // MARK: - Modal Handling

    // 작성화면 모달 띄우는 메서드
    private func modalWriteViewController() {
        let writeViewController = WriteViewController(writeViewModel: .init(currentHangdamID: viewModel.hangdam.id))
        writeViewController.delegate = self                                     // Delegate 연결
        writeViewController.modalTransitionStyle = .coverVertical               // 모달 스타일 설정
        present(writeViewController, animated: true)                            // 모달 표시
    }

    // MARK: - Button Actions

    /// 작성 버튼 클릭 시 호출
    @objc private func createButtonTapped() {
        if viewModel.hasAlreadyWrittenToday() {
            alertManager.showAlert(alertMessage: .alreadyWrittenToday)
            return
        }

        if viewModel.hangdam.name != nil {
            modalWriteViewController()
        } else {
            alertManager.showNameInputAlert { [weak self] name in
                guard let self = self, let name = name, !name.isEmpty else { return }
                self.viewModel.saveNewName(as: name)
                self.modalWriteViewController()
            }
        }
    }

    /// 작성화면으로 이동 후 작성완료 상태를 저장하고 버튼 상태를 갱신하는 메서드
    private func proceedWithWriting() {
        modalWriteViewController()      // 작성화면으로 이동
        viewModel.markAsWrittenToday()  // 오늘 작성 했음을 기록
        updateButtonState()             // 버튼 상태 갱신(작성 완료 시 비활성화됨)
    }

    // MARK: - Gesture Actions

    /// 이미지 탭 액션
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false             // 클릭 비활성화

        // 저정된 이름 유무에 따라서 메세지 업데이트
        viewModel.updateMessage()

        // 1초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true     // 클릭 재활성화
        }
    }
}

// MARK: - extension for delegate

/// 작성화면 모달이 닫힐 때 처리.
extension MainViewController: WriteViewControllerDelegate {
    func writeViewControllerDiddismiss() {
        viewModel.reloadHangdam()   // 데이터 갱신
        viewModel.updateMessage()   // 메시지 업데이트
    }
}
/// 텍스트 입력 제한을 위해 UITextFieldDelegate 구현.
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // 현재 텍스트와 새로운 텍스트를 합친 길이가 4글자를 초과하지 않도록 제한
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 4
    }
}
