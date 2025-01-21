//
//  WriteViewController.swift
//  Sodam
//
//  Created by t2023-m0072 on 1/21/25.
//

import UIKit
import SnapKit

final class WriteViewController: UIViewController {
    
    // MARK: - UI 컴포넌트 선언
    
    // 화면 상단 날짜 레이블
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        label.font = .mapoGoldenPier(20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // 글 작성 텍스트뷰
    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .sejongGeulggot(16)
        textView.textColor = .darkGray
        textView.backgroundColor = .viewBackground
        return textView
    }()
    
    // 이미지뷰를 담을 스택뷰
    private let imageStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    // 카메라 버튼
    private let cameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(useCamera), for: .touchUpInside)
        return button
    }()
    
    // 사진 선택 버튼
    private let photoButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    // 작성 완료 버튼
    private let submitButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(submitText), for: .touchUpInside)
        return button
    }()
    
    // 작성 취소 버튼
    private let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(cancelText), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        let labelWidth = UIScreen.main.bounds.width * 0.5
        let buttonWidth = UIScreen.main.bounds.width * 0.15
        let textViewHeight = UIScreen.main.bounds.height * 0.7
        let imageViewWidth = UIScreen.main.bounds.width * 0.3
        
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
            make.height.equalTo(labelWidth)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(labelWidth)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top)
            make.width.height.equalTo(labelWidth)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.height.equalTo(textViewHeight)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(imageViewWidth)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(20)
            make.width.height.equalTo(buttonWidth)
            make.leading.equalTo(textView.snp.leading)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.width.height.equalTo(buttonWidth)
            make.leading.equalTo(cameraButton.snp.trailing).offset(8)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.width.height.equalTo(buttonWidth)
            make.trailing.equalTo(textView.snp.trailing)
        }
    }
    
    @objc private func useCamera() {
        
    }
    
    @objc private func addPhoto() {
        
    }
    
    @objc private func submitText() {
        
    }
    
    @objc private func cancelText() {
        
    }
    
    @objc private func deleteImage() {
        
    }
}
