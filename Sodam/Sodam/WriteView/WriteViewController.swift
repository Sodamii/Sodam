//
//  WriteViewController.swift
//  Sodam
//
//  Created by 박민석 on 1/21/25.
//

import UIKit
import SnapKit

final class WriteViewController: UIViewController {
    
    private let writeViewModel: WriteViewModel
    private let writeView = WriteView()
    
    init(writeViewModel: WriteViewModel) {
        self.writeViewModel = writeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let writeModel = WriteModel()
        self.writeViewModel = WriteViewModel(writeModel: writeModel)
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeView.setCollectionViewDataSourceDelegate(dataSource: self, delegate: self)
        bindViewModel()
        setupKeyboardNotification()
        setupActions()
    }
    
    private func setupActions() {
        writeView.setCameraButtonAction(target: self, cameraSelector: #selector(openCamera))
        writeView.setPhotoButtonAction(target: self, photoSelector: #selector(addImage))
        writeView.setSubmitButtonAction(target: self, submitSelector: #selector(submitText))
        writeView.setCancelButtonAction(target: self, cancelSelector: #selector(cancelText))
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
        
        // 화면 높이 기준으로 비율 계산 (view.bounds.height 사용)
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
        
        writeView.updateContainerBottomConstraint(inset: 60)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    private func bindViewModel() {
        writeViewModel.output.postUpdated = { [weak self] post in
            self?.updateUI(with: post)
        }
        
        writeViewModel.output.cameraAccessGranted = { [weak self] isGranted in
            if isGranted {
                self?.showCamera()
            } else {
                self?.showAlertGoToSetting()
            }
        }
        
        writeViewModel.output.showImagePicker = { [weak self] picker in
            guard let self = self else { return }
            self.present(picker, animated: true)
        }
    }
    
    // MARK: - 버튼 액션 메서드
    private func updateUI(with post: Post) {
//        textView.text = post.text
        writeView.collectionViewReload()
    }
    
    private func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        present(cameraPicker, animated: true)
    }
    
    // 카메라 버튼 탭할 때 호출되는 메서드
    @objc private func openCamera() {
        writeViewModel.input.cameraAccessRequested()
    }
    
    // 이미지 버튼 탭할 때 호출되는 메서드
    @objc private func addImage() {
        writeViewModel.input.imagePickerRequested()
    }
    
    // 작성완료 버튼 탭할 때 호출되는 메서드
    @objc private func submitText() {
        // Todo: 작성 완료 로직
    }
    
    // 취소 버튼 탭할 때 호출되는 메서드
    @objc private func cancelText() {
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

extension WriteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

}

extension WriteViewController: UICollectionViewDelegate {
    
}

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
