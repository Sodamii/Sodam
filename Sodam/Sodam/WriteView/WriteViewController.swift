//
//  WriteViewController.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/21/25.
//

import UIKit
import SnapKit
import AVFoundation
import PhotosUI

final class WriteViewController: UIViewController {
    
    private let writeViewModel: WriteViewModel = {
        let writeModel = WriteModel()
        return WriteViewModel(writeModel: writeModel)
    }()
    
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
        textView.font = .sejongGeulggot(16)
        textView.textColor = .darkGray
        textView.backgroundColor = .viewBackground
        textView.layer.borderWidth = 1
        return textView
    }()
    
    // 이미지뷰를 담을 스택뷰
    private let imageStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.layer.borderWidth = 1
        return stackView
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
            imageStackView
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
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.2)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(20)
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
        
        // input 설정
        writeViewModel.input = WriteViewModel.Input(
            textUpdated: { [weak self] text in
                self?.writeViewModel.updateText(text)
            },
            cameraAccessReequested: { [weak self] isAuthorized in
                guard let self = self else { return }
                guard isAuthorized else {
                    self.showAlertGoToSetting()
                    return
                }
                DispatchQueue.main.async {
                    let pickerController: UIImagePickerController = UIImagePickerController()
                    pickerController.sourceType = .camera
                    pickerController.allowsEditing = false
                    pickerController.mediaTypes = ["public.image"]
                    pickerController.delegate = self
                    self.present(pickerController, animated: true)
                }
            },
            addImageTapped: { [weak self] viewController in
                self?.writeViewModel.addImage(from: viewController)
            }
        )
        
        // output을 뷰에 바인딩
        writeViewModel.output.postUpdated = { [weak self] post in
            self?.textView.text = post.text
            if let image = post.image {
                let imageView = self?.createImageView(image)
                self?.imageStackView.addArrangedSubview(imageView!)
            }
        }
    }
    
    // 카메라 버튼 탭할 떄 호출되는 메서드
    @objc private func openCamera() {
        // 카메라 사용 권한 요청
        writeViewModel.requestCameraAccess { [weak self] isAuthorized in
            self?.writeViewModel.input.cameraAccessReequested?(isAuthorized)
        }
    }
    
    // 이미지 버튼 탭할 때 호출되는 메서드
    @objc private func addImage() {
        writeViewModel.input.addImageTapped?(self)
    }
    
    // 작성완료 버튼 탭할 때 호출되는 메서드
    @objc private func submitText() {
        writeViewModel.input.textUpdated?(textView.text)
    }
    
    // 취소 버튼 탭할 때 호출되는 메서드
    @objc private func cancelText() {
        // Todo: 글 작성 취소 로직
    }
    
    // 이미지뷰에 있는 휴지통 버튼 탭할 때 호출되는 메서드
    @objc private func deleteImage() {
        // Todo: 이미지 삭제 로직
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
    
    private func createImageView(_ image: UIImage) -> UIView {
        let containerView = UIView()
        containerView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        
        // 이미지 뷰
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 휴지통 버튼
        let deleteButton = UIButton()
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.tintColor = .darkGray
        deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        containerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(24)
        }
        
        return containerView
    }
}

extension WriteViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        // 찍은 이미지 가져오기
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            // 이미지가 유효하지 않은 경우 이미지 선택창 닫기
            picker.dismiss(animated: true)
            return
        }
        
        writeViewModel.updateImage(image)
        picker.dismiss(animated: true)
    }
}

//extension WriteViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
//            return
//        }
//        
//        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//            if let image = image as? UIImage {
//                DispatchQueue.main.async {
//                    self?.writeViewModel.updateImage(image)
//                }
//            }
//        }
//        
//        picker.dismiss(animated: true)
//    }
//}
