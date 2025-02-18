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
<<<<<<< HEAD

=======
    
    // 상태 바 스타일을 검은색으로 고정
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
>>>>>>> 4e440e3b70ef1352b31a8f88e3e5e6f5dfc6ba2b
    weak var delegate: WriteViewControllerDelegate?

    private let writeViewModel: WriteViewModel
    private let writeView = WriteView()
    private let cameraPickerService: ImagePickerServicable
    private let photoLibraryPickerService: ImagePickerServicable

    // 알럿이 항상 필요한게 아니라서 필요할때까지 초기화를 지연시키려고 lazy 사용
    private lazy var alertManager: AlertManager = AlertManager(viewController: self)

    // MARK: - 초기화
    init(writeViewModel: WriteViewModel,
         cameraPickerService: ImagePickerServicable = CameraPickerService(),
         photoLibraryPickerService: ImagePickerServicable = PhotoLibraryPickerService()) {
        self.writeViewModel = writeViewModel
        self.cameraPickerService = cameraPickerService
        self.photoLibraryPickerService = photoLibraryPickerService
        super.init(nibName: nil, bundle: nil)
        self.writeViewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 뷰 생명주기

    // 뷰를 로드할 때 WriteView를 루트 뷰로 설정
    override func loadView() {
        view = writeView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 임시 저장글 있는지 확인하고 로드
        writeViewModel.loadTemporaryPost()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // 컬렉션 뷰의 데이터 소스와 델리게이트 설정
        writeView.setCollectionViewDataSource(dataSource: self)

        cameraPickerService.setDelegate(self)
        photoLibraryPickerService.setDelegate(self)

        // 키보드 알림 설정
        setupKeyboardNotification()

        // 버튼 액션 설정
        setupActions()

        // UITextView의 delegate 설정
        writeView.setTextViewDeleaget(delegate: self)
    }

    // 모달 dismiss 될 때 호출될 메서드
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // 현재 텍스트 저장
        writeViewModel.saveTemporaryPost()

        // 뷰가 닫힐 때 delegate 호출하기
        if self.isBeingDismissed {
            if writeViewModel.isPostSubmitted {
                print("[WriteView] content가 CoreData에 영구저장됨.")
                // 작성 완료시 UserDefaults에 임시 저장된 글 삭제
                UserDefaultsManager.shared.deleteTemporaryPost()
            } else {
                print("[WriteView] content가 UserDefaults에 임시저장됨.")
                // 작성 취소 시 임시 저장
                writeViewModel.saveTemporaryPost()
            }

            delegate?.writeViewControllerDiddismiss()
        }
    }
}

// MARK: - 컬렉션뷰 DataSource 설정
extension WriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return writeViewModel.imageCount
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath
        ) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }

        if let image = writeViewModel.image(at: indexPath.item) {
            cell.configure(with: image)
        }

        // 삭제 클로저 설정
        cell.onDelete = { [weak self] in
            self?.writeViewModel.removeImage(at: indexPath.item)
            collectionView.reloadData()
        }
        return cell
    }
}

// MARK: - 버튼 액션 메서드
extension WriteViewController {
    // WriteView에 정의된 버튼들의 액션 설정 메서드
    private func setupActions() {
        writeView.setCameraButtonAction(target: self, cameraSelector: #selector(openCamera))
        writeView.setImageButtonAction(target: self, imageSelector: #selector(addImage))
        writeView.setSubmitButtonAction(target: self, submitSelector: #selector(submitText))
        writeView.setDismissButtonAction(target: self, dismissSelector: #selector(tapDismiss))
    }

    // 카메라 버튼 탭할 때 호출되는 메서드
    @objc private func openCamera() {
        guard writeViewModel.imageCount < 1 else {
            alertManager.showAlert(alertMessage: .imageLimit)
            return
        }

        cameraPickerService.requestAccess(self) { [weak self] isGranted in
            guard let self = self else { return }
            if isGranted {
                cameraPickerService.show(self)
            } else {
                self.alertManager.showGoToSettingsAlert(for: .camera)
            }
        }
    }

    // 이미지 버튼 탭할 때 호출되는 메서드
    @objc private func addImage() {
        // 이미지 첨부 상한에 도달하면 알림 보내기(현재는 1개)
        guard writeViewModel.imageCount < 1 else {
            alertManager.showAlert(alertMessage: .imageLimit)
            return
        }

        photoLibraryPickerService.requestAccess(self) { [weak self] isGranted in
            guard let self = self else { return }
            if isGranted {
                photoLibraryPickerService.show(self)
            } else {
                // 권한이 거부된 경우 설정 화면으로 이동하는 알림 표시
                self.alertManager.showGoToSettingsAlert(for: .image)
            }
        }
    }

    // 작성완료 버튼 탭할 때 호출되는 메서드
    @objc private func submitText() {
        guard !writeView.getTextViewText().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertManager.showAlert(alertMessage: .emptyText)
            return
        }

        // 키보드 내림
        writeView.dismissKeyboard()

        // 작성 완료 알림 표시
        alertManager.showCompletionAlert { [weak self] in
            self?.writeViewModel.submitPost {
                NotificationCenter.default.post(name: Notification.didWriteToday, object: nil)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }

    // 취소 버튼 탭할 때 호출되는 메서드
    @objc private func tapDismiss() {
        // WriteViewModel에 취소 이벤트 전달
        writeViewModel.cancelPost()
        // 모달 닫기
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - 키보드 관련 메서드
extension WriteViewController {
    // 키보드 감지
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(
                keyboardWillHide(
                    _:
                )
            ),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    // 키보드 내리기 구현
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) // 키보드 내리기
    }

    // 키보드 나타날 때 호출되는 메서드
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo, // 키보드가 나타날 때 프레임 및 애니메이션 시간 정보 저장
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, // 키보드 크기와 위치 저장
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { // userInfo 중 애니메이션 지속 시간 저장
            return
        }

        // 키보드 높이를 기준으로 inset 설정
        let keyboardHeight = keyboardFrame.height
        let safeAreaBottomInset = view.safeAreaInsets.bottom

        // 동적으로 계산된 inset 적용
        let inset = keyboardHeight - safeAreaBottomInset
        writeView.updateContainerBottomConstraint(inset: inset + 10)

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
        writeView.updateContainerBottomConstraint(inset: 20)

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - ImagePickerServiceDelegate
extension WriteViewController: ImagePickerServiceDelegate {
    /// 선택된 이미지 전달받는 메서드
    func didFinishPicking(_ image: UIImage?) {
        if let image = image {
            writeViewModel.addImage(image)
        } else {
            print("[WriteViewController] 사용자가 이미지 선택을 취소했거나 로드가 실패함")
        }
    }
}

// MARK: - 뷰 업데이트
extension WriteViewController: WriteViewModelDelegate {
    /// 뷰모델에게 작성 내용 전달받는 메서드
    func didUpdatePost(_ text: String, _ isEmpty: Bool) {
        writeView.setTextViewText(text) // 텍스트뷰 업데이트
        writeView.collectionViewReload() // 컬렉션 뷰 리로드
        writeView.updateCollectionViewConstraint(isEmpty) // 이미지 유무에 따라 컬렉션뷰 숨김처리
    }
}

// MARK: - 텍스트뷰 deleage 설정
extension WriteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 텍스트가 변경될 때마다 뷰모델에 전달
        writeViewModel.updateText(textView.text)
    }
}
