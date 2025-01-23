//
//  WriteViewController.swift
//  Sodam
//
//  Created by 박민석 on 1/21/25.
//

import UIKit
import SnapKit

protocol WriteViewControllerDelegate: AnyObject {
    func writeViewControllerDiddismiss()
}

final class WriteViewController: UIViewController {
    
    weak var delegate: WriteViewControllerDelegate?
    var hangdamName: String? // 전달받을 이름
    
    private let writeViewModel: WriteViewModel
    private let writeView = WriteView()
    
    // 초기화
    init(writeViewModel: WriteViewModel) {
        self.writeViewModel = writeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let writeModel = WriteModel()
        self.writeViewModel = WriteViewModel(writeModel: writeModel)
        super.init(coder: coder)
    }
    
    // 뷰를 로드할 때 WriteView를 루트 뷰로 설정
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 컬렉션 뷰의 데이터 소스와 델리게이트 설정
        writeView.setCollectionViewDataSource(dataSource: self)
        
        // 키보드 알림 설정
        setupKeyboardNotification()
        
        // 버튼 액션 설정
        setupActions()
        
        // UITextView의 delegate 설정
        writeView.setTextViewDeleaget(delegate: self)
        
        // 뷰모델의 데이터 변경을 관찰
        writeViewModel.bindPostUpdated { [weak self] post in
            self?.updateUI(with: post)
        }
    }
    
    // 모달 dismiss 될 때 호출될 메서드
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 뷰가 닫힐 때 delegate 호출하기
        if self.isBeingDismissed {
            delegate?.writeViewControllerDiddismiss()
        }
    }
    
    // WriteView에 정의된 버튼들의 액션 설정 메서드
    private func setupActions() {
        writeView.setCameraButtonAction(target: self, cameraSelector: #selector(openCamera))
        writeView.setImageButtonAction(target: self, imageSelector: #selector(addImage))
        writeView.setSubmitButtonAction(target: self, submitSelector: #selector(submitText))
        writeView.setDismissButtonAction(target: self, dismissSelector: #selector(tapDismiss))
    }
    
    // 키보드 감지
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 키보드 나타날 때 호출되는 메서드
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, // 키보드가 나타날 때 프레임 및 애니메이션 시간 정보 저장
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, // 키보드 크기와 위치 저장
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { // userInfo 중 애니메이션 지속 시간 저장
            return
        }
        
        // 화면 높이 기준으로 키보드 높이 비율 계산
        let screenHeight = view.bounds.height
        let keyboardHeightRatio = keyboardFrame.height / screenHeight

        // 동적으로 계산된 inset 적용
        let inset = view.safeAreaLayoutGuide.layoutFrame.height * keyboardHeightRatio
        writeView.updateContainerBottomConstraint(inset: inset)
        
        // 업데이트 된 레이아웃 반영
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드 사라질 때 호출되는 메서드
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        // 키보드가 사라지면 컨테이너 뷰의 제약 조건을 원래대로 복원
        writeView.updateContainerBottomConstraint(inset: 60)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // UI 업데이트 메서드
    private func updateUI(with post: Post) {
        writeView.setTextViewText(post.text) // 텍스트뷰 업데이트
        writeView.collectionViewReload() // 컬렉션 뷰 리로드
    }
    
    // MARK: - 버튼 액션 메서드
    
    // 카메라 버튼 탭할 때 호출되는 메서드
    @objc private func openCamera() {
        writeViewModel.requestCameraAccess { [weak self] isGranted in
            if isGranted {
                // 카메라 권한이 허용된 경우 카메라 생성 및 표시
                let cameraPicker = self?.writeViewModel.createCameraPicker()
                if let picker = cameraPicker {
                    self?.present(picker, animated: true)
                }
            } else {
                // 권한이 거부된 경우 설정 화면으로 이동하는 알림 표시
                self?.showAlertGoToSetting()
            }
        }
    }
    
    // 이미지 버튼 탭할 때 호출되는 메서드
    @objc private func addImage() {
        writeViewModel.requestPhotoLibraryAccess { [weak self] isGranted in
            if isGranted {
                // 사진 라이브러리 권한이 허용된 경우 사진 피커 생성 및 표시
                let photoPicker = self?.writeViewModel.createPhotoPicker()
                if let picker = photoPicker {
                    self?.present(picker, animated: true)
                }
            } else {
                // 권한이 거부된 경우 설정 화면으로 이동하는 알림 표시
                self?.showAlertGoToSetting()
            }
        }
    }
    
    // 작성완료 버튼 탭할 때 호출되는 메서드
    @objc private func submitText() {
        // Todo: 작성 완료 로직
    }
    
    // 취소 버튼 탭할 때 호출되는 메서드
    @objc private func tapDismiss() {
        // 모달 닫기
        dismiss(animated: true, completion: nil)
        // Todo: 글 작성 취소 로직
    }

    // 카메라 권한이 없는 경우 설정 화면으로 이동하는 Alert 표시
    private func showAlertGoToSetting() {
        let alertControlelr  = UIAlertController(
            title: "현재 카메라 사용에 대한 접근 권한이 없습니다.",
            message: "설정 > Sodam 탭에서 접근 권한을 활성화 해주세요.",
            preferredStyle: .alert
        )
        
        // 취소 버튼
        let cancelAlert = UIAlertAction(title: "취소", style: .cancel) { _ in
            alertControlelr.dismiss(animated: true, completion: nil)
        }
        
        // 설정으로 이동하는 버튼
        let doneAlert = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(settingURL)
            else {
                return
            }
            UIApplication.shared.open(settingURL, options: [:])
        }
        
        // Alert에 버튼 추가
        [
            cancelAlert,
            doneAlert
        ].forEach(alertControlelr.addAction(_:))
        
        // Alert 표시
        DispatchQueue.main.async {
            self.present(alertControlelr, animated: true)
        }
    }
}

// MARK: - 컬렉션뷰 DataSource 설정

extension WriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return writeViewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let image = writeViewModel.images[indexPath.item]
        cell.configure(with: image)
        
        // 삭제 클로저 설정
        cell.onDelete = { [weak self] in
            self?.writeViewModel.removeImage(at: indexPath.item)
            collectionView.reloadData()
        }
        return cell
    }
}

// MARK: - 텍스트뷰 deleage 설정

extension WriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트가 변경될 때마다 뷰모델에 전달
        writeViewModel.updateText(textView.text)
    }
}
