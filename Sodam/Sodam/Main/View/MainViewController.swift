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
    
    private let mainView: MainView  = MainView()
    private let viewModel: MainViewModel = MainViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    // MARK: - Lifecycle Methods
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()            // viewModel과 view를 바인딩
        configureButtonAction()    // 작성 버튼 액션 설정
        addGesture()               // 이미지 탭 제스처 설정
    }
    
    /// 뷰가 다시 나타날 때 데이터 갱신
    override func viewIsAppearing(_ animated: Bool) {
        viewModel.reloadHanhdam() // ViewModel에서 행담이 데이터를 갱신
    }
    
    // MARK: - bind view model for update view
    
    /// ViewModel과 View를 바인딩 해서 데이터 변화를 UI에 반영함.
    private func bindViewModel() {
        viewModel.$hangdam
            .receive(on: RunLoop.main)
            .sink { [weak self] hangdam in
                self?.mainView.updateNameLabel(hangdam.name ?? "이름을 지어주세요") // 이름 설정
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
    
    // MARK: - Lazy Properties
    
    /// 작성 화면을 위한 ViewModel 생성. (행담이 ID와 함께 초기화)
    private lazy var writeViewModel: WriteViewModel = .init(writeModel: WriteModel(), hangdamID: viewModel.getCurrentHangdamID())
    
    // MARK: - Modal Handling
    
    // 작성화면 모달 띄우는 메서드
    private func modalWriteViewController(with name: String) {
        let writeViewController = WriteViewController(writeViewModel: writeViewModel)
        writeViewController.hangdamName = name                                  // 지어진 이름 작성화면으로 전달
        writeViewController.delegate = self                                     // Delegate 연결
        writeViewController.modalTransitionStyle = .coverVertical               // 모달 스타일 설정
        present(writeViewController, animated: true)                            // 모달 표시
    }
    
    // MARK: - Button Actions
    
    /// 작성 버튼 클릭 시 호출
    @objc private func createButtonTapped() {
        if let name = viewModel.hangdam.name {
            // 이미 저장된 이름이 있는 경우에 바로 작성화면으로 이동
            print("저장된 이름으로 작성화면 이동함: \(name)")
            modalWriteViewController(with: name)
        } else {
            // 저장된 이름이 없는 경우 알림창 표시
            AlertManager.showAlert(on: self) { [weak self] name in
                guard let self = self,
                      let name = name,
                      !name.isEmpty
                else {
                    print("이름이 입력되지 않았습니다.")
                    return
                }
                viewModel.saveNewName(as: name) // 새 이름 저장
                print("입력 된 이름: \(name)")
                self.modalWriteViewController(with: name) // 작성 화면으로 이동
            }
        }
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
        print("WriteViewController 모달이 닫혔습니다.")
        viewModel.reloadHanhdam() // 데이터 갱신
    }
}
/// 텍스트 입력 제한을 위해 UITextFieldDelegate 구현.
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 현재 텍스트와 새로운 텍스트를 합친 길이가 6글자를 초과하지 않도록 제한
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 6
    }
}
