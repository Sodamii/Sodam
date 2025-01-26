//
//  MainViewController.swift
//  Sodam
//
//  Created by 손겸 on 1/21/25.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    
    //뷰, 뷰모델 연결
    private let mainView: MainView  = MainView()
    private let viewModel: MainViewModel = MainViewModel()
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureButtonAction()    // 작성 버튼 액션 설정
        addGesture()               // 이미지 탭 제스처
    }
    
    // MARK: - bind view model for update view
    
    private func bindViewModel() {
        viewModel.$name
            .receive(on: RunLoop.main)
            .sink { [weak self] name in
                self?.mainView.updateNameLabel(name ?? "알 수 없는 알") // TODO: 이름이 안 정해졌을 때 비워두는 것보다 귀여운 이름 넣으면 좋을 거 같아요
            }
            .store(in: &cancellables)
        
        viewModel.$message
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.mainView.updateMessage(message)
            }
            .store(in: &cancellables)
        
        viewModel.$gifName
            .receive(on: RunLoop.main)
            .sink { [weak self] gifName in
                self?.mainView.updateGif(with: gifName)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - setup button action
    
    // 작성 버튼 클릭 시 액션 설정
    private func configureButtonAction() {
        mainView.createbutton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    // 이미지 뷰 탭할 때 액션 설정
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTap))
        mainView.circularImageView.addGestureRecognizer(tapGesture)
        mainView.circularImageView.isUserInteractionEnabled = true
    }
    
    private lazy var writeViewModel: WriteViewModel = .init(writeModel: WriteModel(), hangdamID: viewModel.getCurrentHangdamID())
    
    // 작성화면 모달 띄우는 메서드
    private func modalWriteViewController(with name: String) {
        let writeViewController = WriteViewController(writeViewModel: writeViewModel)
        writeViewController.hangdamName = name                                  // 지어진 이름 작성화면으로 전달
        writeViewController.delegate = self                                     // Delegate 연결
        writeViewController.modalTransitionStyle = .coverVertical               // 모달 스타일 설정
        present(writeViewController, animated: true)                            // 모달 표시
    }
    
    // 작성 버튼 클릭 시 호출
    @objc private func createButtonTapped() {
        if let name = viewModel.name {
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
                viewModel.saveNewName(as: name)
                print("입력 된 이름: \(name)")
                self.modalWriteViewController(with: name) // 작성 화면으로 이동
            }
        }
    }
    
    // 이미지 탭 액션
    @objc private func imageViewTap() {
        // 연속 클릭 방지
        mainView.circularImageView.isUserInteractionEnabled = false             // 클릭 비활성화
        
        // 저정된 이름 유무에 따라서 메세지 업데이트
        viewModel.updateMessage()
        
        // 2초 후 다시 활성화
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.mainView.circularImageView.isUserInteractionEnabled = true     // 클릭 재활성화
        }
    }
}

// MARK: - extension for delegate

// 작성화면 모달이 닫힐 때 처리
extension MainViewController: WriteViewControllerDelegate {
    func writeViewControllerDiddismiss() {
        print("WriteViewController 모달이 닫혔습니다.")
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트와 새로운 텍스트를 합친 길이가 6글자를 초과하지 않도록 제한
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        return newText.count <= 6
    }
}
