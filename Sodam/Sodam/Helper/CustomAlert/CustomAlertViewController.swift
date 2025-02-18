//
//  CustomAlertViewController.swift
//  Sodam
//
//  Created by 박진홍 on 1/24/25.
//

import UIKit
import SwiftUI

final class CustomAlertViewController: UIViewController {
    private let config: AlertConfiguration
    private var textField: UITextField?

    init(config: AlertConfiguration) {
        self.config = config
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // 알럿 창 뒤를 살짝 어둡게 처리

        let alertView: UIView = {
            let instance: UIView = UIView()
            instance.backgroundColor = config.backgroundColor
            instance.layer.cornerRadius = config.cornerRadius
            instance.translatesAutoresizingMaskIntoConstraints = false
            return instance
        }()

        let stackView: UIStackView = {
            let instance: UIStackView = UIStackView()
            instance.axis = .vertical
            instance.spacing = 16
            instance.translatesAutoresizingMaskIntoConstraints = false
            return instance
        }()

        if let title = config.title {
            let titleLabel: UILabel = {
                let instance: UILabel = UILabel()
                instance.text = title
                instance.font = config.alertFont
                instance.textColor = config.titleColor
                instance.textAlignment = .center
                return instance
            }()

            stackView.addArrangedSubview(titleLabel)
        }

        if let message = config.message {
            let messageLabel: UILabel = {
                let instance: UILabel = UILabel()
                instance.text = message
                instance.font = config.alertFont
                instance.textColor = config.messageColor
                instance.textAlignment = .center
                return instance
            }()

            stackView.addArrangedSubview(messageLabel)
        }

        if let placeHoler = config.textFieldPlaceHolder {
            let textField: UITextField = {
                let instance: UITextField = UITextField()
                instance.placeholder = placeHoler
                instance.borderStyle = .roundedRect
                return instance
            }()

            self.textField = textField
            stackView.addArrangedSubview(textField)
        }

        let buttonStack: UIStackView = {
            let instance: UIStackView = UIStackView()
            instance.axis = .horizontal
            instance.distribution = .fillEqually
            instance.spacing = 8
            return instance
        }()

        for action in config.actions {
            let button: UIButton = {
                let instance: UIButton = UIButton()
                instance.setTitle(action.title, for: .normal)
                instance.addTarget(self, action: #selector(handlerAction(sender:)), for: .touchUpInside)
                instance.tag = config.actions.firstIndex {
                    $0.title == action.title
                } ?? 0
                return instance
            }()

            switch action.style {
            case .onlyYes:
                button.setTitleColor(.textAccent, for: .normal)
            case .canCancle:
                button.setTitleColor(.systemRed, for: .normal)
            }

            buttonStack.addArrangedSubview(button)
        }

        stackView.addArrangedSubview(buttonStack)
        alertView.addSubview(stackView)
        view.addSubview(alertView)

        NSLayoutConstraint.activate([
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),

            stackView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -1)
        ])
    }

    @objc private func handlerAction(sender: UIButton) {
        let action = config.actions[sender.tag]
        dismiss(animated: true) {
            action.handler(self.textField?.text)
        }
    }
}

// for use in swift ui
struct CustomAlertRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    let alertBuilder: CustomAlertBuilder

    func makeUIViewController(context: Context) -> some UIViewController {
        alertBuilder.build()
    }
}
