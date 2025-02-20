//
//  WriteView.swift
//  Sodam
//
//  Created by 박민석 on 1/23/25.
//

import UIKit
import SnapKit

class WriteView: UIView {

    // 제약 조건 변수 선언
    private var containerBottomConstraint: Constraint?

    // MARK: - UI 컴포넌트 선언

    // 화면 상단 날짜 레이블
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Date().formatForHappiness
        label.font = .appFont(size: .subtitle)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    // 글 작성 텍스트뷰
    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.textColor = .darkGray
        textView.backgroundColor = .viewBackground
        return textView
    }()

    // 텍스트뷰에 띄울 placeholder
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "행복을 작성해주세요"
        label.font = .appFont(size: .body2)
        label.textColor = .lightGray
        return label
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
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        return collectionView
    }()

    // 카메라 버튼
    private let cameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.tintColor = .darkGray
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "camera")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20) // 이미지 크기 설정
        button.configuration = config
        return button
    }()

    // 사진 선택 버튼
    private let imageButton: UIButton = {
        let button: UIButton = UIButton()
        button.tintColor = .darkGray
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "photo.on.rectangle")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        return button
    }()

    // 작성 완료 버튼
    private let submitButton: UIButton = {
        let button: UIButton = UIButton()
        button.tintColor = .darkGray
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "checkmark")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        return button
    }()

    // dismiss 버튼
    private let dismisslButton: UIButton = {
        let button: UIButton = UIButton()
        button.tintColor = .darkGray
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        return button
    }()

    // 바 추가
    private let topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray // 바의 배경색
        view.layer.cornerRadius = 4 // 모서리 둥글기
        return view
    }()

    // 버튼을 담을 컨테이너 뷰
    private let buttonContainerView: UIView = UIView()
    
    // 현재 글자 수 표기 레이블
    private let characterCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .darkGray
        label.font = .sejongGeulggot(14)
        label.text = "0 / 500"
        return label
    }()
    
    // 텍스트뷰와 글자수 레이블을 담을 컨테이너 뷰
    private let textContainerView: UIView = UIView()

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
}

// MARK: - UI 레이아웃 메서드
extension WriteView {
    // UI 셋업
    private func setupUI() {
        backgroundColor = .viewBackground

        buttonContainerView.addSubViews([cameraButton, imageButton, submitButton])
        textContainerView.addSubViews([textView, characterCountLabel])
        self.addSubViews([dateLabel, textContainerView, placeholderLabel, collectionView, dismisslButton, buttonContainerView, topBar])
        
        // 바 제약 조건 설정
        topBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(5)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(80)
        }

        dismisslButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.width.height.equalTo(36)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }

        buttonContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
            containerBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20).constraint
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.25)
            make.bottom.equalTo(buttonContainerView.snp.top)
        }

        textContainerView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.bottom.equalTo(collectionView.snp.top)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        characterCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(characterCountLabel.snp.top)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(textView).offset(8)
        }

        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(buttonContainerView.snp.bottom)
            make.width.height.equalTo(36)
            make.leading.equalTo(textView.snp.leading)
        }

        imageButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton)
            make.width.height.equalTo(36)
            make.leading.equalTo(cameraButton.snp.trailing).offset(16)
        }

        submitButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraButton)
            make.width.height.equalTo(36)
            make.trailing.equalTo(textView.snp.trailing)
        }
    }

    // 하단 UI constraints 조절 메서드
    func updateContainerBottomConstraint(inset: CGFloat) {
        containerBottomConstraint?.update(inset: inset)
    }
}

// MARK: - 컬렉션뷰 메서드
extension WriteView {
    // 컬렉션뷰 dataSource 설정 메서드
    func setCollectionViewDataSource(dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }

    // 컬렉션뷰 리로드 메서드
    func collectionViewReload() {
        collectionView.reloadData()
    }

    func updateCollectionViewConstraint(_ isHidden: Bool) {
        collectionView.isHidden = isHidden

        if isHidden {
            collectionView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }

            textContainerView.snp.remakeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(20)
                make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
                make.bottom.equalTo(buttonContainerView.snp.top)
            }
        } else {
            collectionView.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
                make.height.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.25)
                make.bottom.equalTo(buttonContainerView.snp.top)
            }

            textContainerView.snp.remakeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(20)
                make.bottom.equalTo(collectionView.snp.top)
                make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            }
        }

        self.layoutIfNeeded()
    }
}

// MARK: - 텍스트뷰 메서드
extension WriteView {
    // placeholder 숨김처리 메서드
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    // 텍스트뷰 줄 간격 설정 메서드 추가
    private func updateTextViewAttributes() {
        let font = UIFont.appFont(size: .body2)
        let lineHeight = font.lineHeight // 폰트는 기본 줄 높이
        let swiftUILineSpacing: CGFloat = 10 // SwiftUI에서 사용한 lineSpacing 값

        // UIKit의 lineSpacing 계산 (SwiftUI와 일치시키기)
        let adjustedLineSpacing = swiftUILineSpacing - (lineHeight - font.pointSize)

        let parapraphStyle = NSMutableParagraphStyle()
        parapraphStyle.lineSpacing = adjustedLineSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: parapraphStyle,
            .font: font
        ]

        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)
    }

    // 텍스트뷰 delegate 설정 메서드
    func setTextViewDelegate(delegate: UITextViewDelegate) {
        textView.delegate = delegate
    }

    // 텍스트뷰 내용 접근 메서드
    func getTextViewText() -> String {
        return textView.text
    }

    // 텍스트뷰 내용 변경 메서드
    func setTextViewText(_ text: String) {
        textView.text = text
        updatePlaceholderVisibility() // 텍스트 변경 시 Placeholder 업데이트
        updateTextViewAttributes() // 텍스트 변경 시 스타일 적용
    }
    
    // 텍스트뷰 입력 활성화 해제 메서드 (키보드 내리기 위함) - 작성 완료 버튼 액션 함수에서 호출
    func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    // 현재 글자수 표시 메서드
    func setCharacterLimitLabel(_ limit: Int) {
        characterCountLabel.text = "\(limit) / 500"
    }
}

// MARK: - 버튼 액션 설정
extension WriteView {
    // 카메라 버튼 액션 설정 메서드
    func setCameraButtonAction(target: Any, cameraSelector: Selector) {
        cameraButton.addTarget(target, action: cameraSelector, for: .touchUpInside)
    }

    // 사진 버튼 액션 설정 메서드
    func setImageButtonAction(target: Any, imageSelector: Selector) {
        imageButton.addTarget(target, action: imageSelector, for: .touchUpInside)
    }

    // 작성완료 버튼 액션 설정 메서드
    func setSubmitButtonAction(target: Any, submitSelector: Selector) {
        submitButton.addTarget(target, action: submitSelector, for: .touchUpInside)
    }

    // dismiss 버튼 액션 설정 메서드
    func setDismissButtonAction(target: Any, dismissSelector: Selector) {
        dismisslButton.addTarget(target, action: dismissSelector, for: .touchUpInside)
    }
}
