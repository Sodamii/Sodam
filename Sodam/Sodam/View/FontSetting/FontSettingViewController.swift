//
//  FontSettingViewController.swift
//  Sodam
//
//  Created by 박시연 on 2/18/25.
//

import UIKit

final class FontSettingViewController: UIViewController, UINavigationBarDelegate {
    private let fontSettingViewModel: FontSettingViewModel
    private let settingView = SettingView()
    
    // MARK: - Initializer

    init(fontSettingViewModel: FontSettingViewModel) {
        self.fontSettingViewModel = fontSettingViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = settingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBarTitle()
        setupNavigationBarItem()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Private Methods

private extension FontSettingViewController {
    // UI Set
    func setupUI() {
        view.backgroundColor = .viewBackground
        setupTableView()
    }
    
    func setupNavigationBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "폰트 설정"
        titleLabel.font = .appFont(size: .subtitle)
        titleLabel.textColor = .textAccent
        navigationItem.titleView = titleLabel
    }

    // NavigationBar Left Item
    func setupNavigationBarItem() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 기본 배경 설정
        appearance.backgroundColor = .clear  // 배경 투명하게
        appearance.shadowColor = nil  // 그림자 제거
        
        // 기본 네비게이션 바 설정
        navigationController?.navigationBar.standardAppearance = appearance
        // 스크롤할 때 적용될 appearance (투명 처리)
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        // 네비게이션 좌측 아이템
        let barBackButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(handleBackButton))
        barBackButton.tintColor = .textAccent
        navigationItem.leftBarButtonItem = barBackButton
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    // 네비게이션 스택에서 이전 화면으로 이동
    @objc func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    // TableView Set
    func setupTableView() {
        settingView.tableView.dataSource = self
        settingView.tableView.delegate = self
        settingView.tableView.separatorInset.right = 15
        
        settingView.tableView.register(FontSettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
    }
    
    func setupBindings() {
        fontSettingViewModel.updateFontSelectionUI = { [weak self] indexPath in
            guard let self = self, let indexPath = indexPath else {
                return
            }

            let selectedFont = self.fontSettingViewModel.customFontTypes[indexPath.row]
            CustomFontManager.setFont(selectedFont.sourceName) // 앱 전역 폰트 변경
            
            DispatchQueue.main.async {
                self.settingView.tableView.reloadData()
                self.setupNavigationBarTitle() // 네비게이션 바 타이틀 업데이트
            }
        }
    }
}

// MARK: - UITableView Method

extension FontSettingViewController: UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return fontSettingViewModel.customFontTypes.count
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? FontSettingTableViewCell else {
            return UITableViewCell()
        }

        let customFonts = fontSettingViewModel.customFontTypes[indexPath.row]
        let isSelected = fontSettingViewModel.selectedIndexPath == indexPath
        
        cell.indexPath = indexPath
        cell.configure(customFont: customFonts, isSelected: isSelected)
        cell.didTapFontCellHandler = { [weak self] in
            self?.fontSettingViewModel.selectedFont(indexPath: indexPath)
        }

        return cell
    }
}
