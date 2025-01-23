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
        label.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
        label.font = .mapoGoldenPier(20)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // 글 작성 텍스트뷰
    private let textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = .sejongGeulggot(18)
        textView.textColor = .darkGray
        textView.backgroundColor = .viewBackground
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
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        return collectionView
    }()
    
    // 카메라 버튼
    private let cameraButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // 사진 선택 버튼
    private let photoButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // 작성 완료 버튼
    private let submitButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    // 작성 취소 버튼
    private let cancelButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .viewBackground
        
        dateLabel.layer.borderWidth = 1
        textView.layer.borderWidth = 1
        collectionView.layer.borderWidth = 1
        cameraButton.layer.borderWidth = 1
        photoButton.layer.borderWidth = 1
        cancelButton.layer.borderWidth = 1
        submitButton.layer.borderWidth = 1
        
        
        let containerView: UIView = UIView()
        [
            collectionView,
            cameraButton,
            photoButton,
            submitButton,
        ].forEach { containerView.addSubview($0) }
        
        containerView.layer.borderWidth = 1
        
        [
            dateLabel,
            textView,
            cancelButton,
            containerView
        ].forEach { addSubview($0) }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(80)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel.snp.centerY)
            make.width.height.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.1)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.6)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.2)
            containerBottomConstraint = make.bottom.equalTo(safeAreaLayoutGuide).inset(60).constraint
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(safeAreaLayoutGuide.snp.width).multipliedBy(0.25)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.bottom.equalTo(containerView.snp.bottom)
            make.width.equalTo(cameraButton.snp.height)
            make.leading.equalTo(textView.snp.leading)
        }
        
        photoButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.centerY.equalTo(cameraButton)
            make.width.equalTo(photoButton.snp.height)
            make.leading.equalTo(cameraButton.snp.trailing).offset(8)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(cameraButton.snp.top)
            make.centerY.equalTo(cameraButton)
            make.width.equalTo(submitButton.snp.height)
            make.trailing.equalTo(textView.snp.trailing)
        }
    }
    
    func updateContainerBottomConstraint(inset: CGFloat) {
        containerBottomConstraint?.update(inset: inset)
    }
    
    func setCollectionViewDataSourceDelegate(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    func setCameraButtonAction(target: Any, cameraSelector: Selector) {
        cameraButton.addTarget(target, action: cameraSelector, for: .touchUpInside)
    }
    func setPhotoButtonAction(target: Any, photoSelector: Selector) {
        photoButton.addTarget(target, action: photoSelector, for: .touchUpInside)
    }
    func setSubmitButtonAction(target: Any, submitSelector: Selector) {
        submitButton.addTarget(target, action: submitSelector, for: .touchUpInside)
    }
    func setCancelButtonAction(target: Any, cancelSelector: Selector) {
        cancelButton.addTarget(target, action: cancelSelector, for: .touchUpInside)
    }
    
    func collectionViewReload() {
        collectionView.reloadData()
    }
}
