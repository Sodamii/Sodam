//
//  WriteViewController.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/21/25.
//

import UIKit
import SnapKit

final class WriteViewController: UIViewController {
    
    private let writeViewModel: WriteViewModel
    
    init(writeViewModel: WriteViewModel) {
        self.writeViewModel = writeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let writeModel = WriteModel()
        self.writeViewModel = WriteViewModel(writeModel: writeModel)
        super.init(coder: coder)
    }
    // MARK: - UI 컴포넌트 선언
    
    // 화면 상단 날짜 레이블
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        label.font = .mapoGoldenPier(20)
        label.textColor = .black
        label.textAlignment = .center
        label.layer.borderWidth = 1
        return label
    }()
    
    // 글 작성 텍스트뷰
    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .sejongGeulggot(18)
        textView.textColor = .darkGray
        textView.backgroundColor = .viewBackground
        textView.layer.borderWidth = 1
        return textView
    }()
    
    // 이미지뷰를 담을 컬렉션뷰
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumInteritemSpacing = 8
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .viewBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.layer.borderWidth = 1
        return collectionView
    }()
    
    // 카메라 버튼
    private let cameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    // 사진 선택 버튼
    private let photoButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    // 작성 완료 버튼
    private let submitButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(submitText), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    // 작성 취소 버튼
    private let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(cancelText), for: .touchUpInside)
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .viewBackground
        [
            dateLabel,
            textView,
            cameraButton,
            photoButton,
            submitButton,
            cancelButton,
            collectionView
        ].forEach { view.addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.1)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.6)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.2)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.1)
            make.leading.equalTo(textView.snp.leading)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.1)
            make.leading.equalTo(cameraButton.snp.trailing).offset(8)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.width.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.1)
            make.trailing.equalTo(textView.snp.trailing)
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
        textView.text = post.text // UI 업데이트 예시
        collectionView.reloadData()
    }
    
    private func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = .camera
        cameraPicker.delegate = self
        present(cameraPicker, animated: true)
    }
    
    // 카메라 버튼 탭할 떄 호출되는 메서드
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
