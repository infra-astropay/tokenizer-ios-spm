//
//  CardCollectUIKitView.swift
//  Tokenizer
//
//  Created by Rodrigo Cámara Robles on 06/09/2024.
//

import UIKit
import Tokenizer

final class CardCollectUIKitView: UIViewController {    
    
    private var tokenCollector: TokenCollectorProtocol
    private var isLabelShown = false
    private var copyTextToClipBoard = false
    
    var cardFieldName = Constants.Text.fieldNameCardNumber
    var cardExpirationDateFieldName = Constants.Text.fieldNameCardExpirationDate
    var cvvFieldName = Constants.Text.fieldNameCvv
    var confirmCvvFieldName = Constants.Text.fieldNameConfirmCvv
    
    private lazy var titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.collect
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var secureCardNumberTextField: SecureTextFieldProtocol = {
        let view = ComponentBuilder.createSecureTextField(
            viewModel: .init(fieldName: cardFieldName,
                             fieldType: .cardNumber(CardNumberMaskFormatter()),
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.collectCardNumberPlaceholder,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             )),
            onStateChange: { newState in
                print("New state with description \(newState.description)")
                self.setBorderColor(for: self.secureCardNumberTextField)
            },
            tokenCollector: tokenCollector)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var secureCardExpirationDateTextField: SecureTextFieldProtocol = {
        let view = ComponentBuilder.createSecureTextField(
            viewModel: .init(fieldName: cardExpirationDateFieldName,
                             fieldType: .expDate(CardExpirationDateMaskFormatter(dateFormat: .shortYear)),
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.collectCardExpirationDatePlaceholder,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                                borderColor: .clear,
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             )),
            onStateChange: { newState in
                print("New state with description \(newState.description)")
                self.setBorderColor(for: self.secureCardExpirationDateTextField)
            },
            tokenCollector: tokenCollector)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private lazy var secureCVVNumberTextField: SecureTextFieldProtocol = {
        let view = ComponentBuilder.createSecureTextField(
            viewModel: .init(fieldName: cvvFieldName,
                             maxLength: 5,
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.cvv,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 16),
                                borderColor: .clear,
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             ),
                             isVolatile: true),
            onStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.setBorderColor(for: self.secureCVVNumberTextField)
            },
            tokenCollector: tokenCollector)
        return view
    }()
    
    private lazy var secureConfirmCVVNumberTextField: SecureTextFieldProtocol = {
        let view = ComponentBuilder.createSecureTextField(
            viewModel: .init(fieldName: confirmCvvFieldName,
                             validationRules: .init(rules: [
                                RegexRuleValidation(pattern: Constants.ValidationPattern.fourDigitNumberPattern,
                                                    error: Constants.ValidationPattern.fourDigitNumberPatternMessage)
                             ]),
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.confirmCvv,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 16),
                                borderColor: .clear,
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             ),
                             isVolatile: true),
            onStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.setBorderColor(for: self.secureConfirmCVVNumberTextField)
            },
            onValidationFailure: { failures in
                print("Failed rules: \(failures)")
                print("")
            },
            tokenCollector: tokenCollector)
        return view
    }()
    
    private lazy var collectButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Text.collect
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .medium
        configuration.titlePadding = 8
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(captureData), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var areEqualButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Text.areEqual
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .medium
        configuration.titlePadding = 8
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(areEqualAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resultView: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.result
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(tokenCollector: TokenCollectorProtocol) {
        self.tokenCollector = tokenCollector
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setUpView()
        secureCardNumberTextField.becomeFirstResponder()
    }
    
    deinit {
        tokenCollector.unsubscribeAllViews()
    }
    
    private func setUpView() {
        view.addSubview(titleView)
        view.addSubview(secureCardNumberTextField)
        view.addSubview(secureCardExpirationDateTextField)
        view.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(secureCVVNumberTextField)
        horizontalStack.addArrangedSubview(secureConfirmCVVNumberTextField)
        
        view.addSubview(collectButton)
        view.addSubview(areEqualButton)
        view.addSubview(resultView)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            secureCardNumberTextField.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            secureCardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secureCardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            secureCardExpirationDateTextField.topAnchor.constraint(equalTo: secureCardNumberTextField.bottomAnchor, constant: 8),
            secureCardExpirationDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secureCardExpirationDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            horizontalStack.topAnchor.constraint(equalTo: secureCardExpirationDateTextField.bottomAnchor, constant: 8),
            horizontalStack.leadingAnchor.constraint(equalTo: secureCardNumberTextField.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: secureCardNumberTextField.trailingAnchor),
            
            collectButton.topAnchor.constraint(equalTo: secureCVVNumberTextField.bottomAnchor, constant: 16),
            collectButton.trailingAnchor.constraint(equalTo: secureCardNumberTextField.trailingAnchor),
            
            areEqualButton.topAnchor.constraint(equalTo: collectButton.bottomAnchor, constant: 16),
            areEqualButton.trailingAnchor.constraint(equalTo: secureCardNumberTextField.trailingAnchor),
            
            resultView.topAnchor.constraint(equalTo: areEqualButton.bottomAnchor, constant: 16),
            resultView.leadingAnchor.constraint(equalTo: secureCardNumberTextField.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: secureCardNumberTextField.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: resultView.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: secureCardNumberTextField.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: secureCardNumberTextField.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
            
        ])
    }
    
    @objc private func captureData() {
        textView.text = Constants.Text.performingRequest
        tokenCollector.collectSubscribedViews { result in
            switch result {
            case .success(let values):
                self.textView.text = values
                    .map { "\($0.key) = \($0.value)" }
                    .joined(separator: "\n")
            case .failure(let error):
                self.textView.text = error.localizedDescription
            }
        }
    }
    
    @objc private func areEqualAction() {
        textView.text = tokenCollector.isContentEquals(cvvFieldName, confirmCvvFieldName) ? Constants.Text.areEqueal: Constants.Text.areNotEqueal
    }
    
    private func setBorderColor(for secureTextFieldProtocol: SecureTextFieldProtocol) {
        guard let state = secureTextFieldProtocol.state as? SecureTextFieldState else {
            secureTextFieldProtocol.setBorderColor(.clear)
            secureTextFieldProtocol.setBorderWidth(0.0)
            return
        }
        if state.isFocused {
            secureTextFieldProtocol.setBorderWidth(2.0)
            if state.isValid || state.isEmpty {
                secureTextFieldProtocol.setBorderColor(.green)
            } else {
                secureTextFieldProtocol.setBorderColor(.red)
            }
        } else {
            secureTextFieldProtocol.setBorderWidth(2.0)
            if state.isValid || state.isEmpty {
                secureTextFieldProtocol.setBorderColor(.clear)
            } else {
                secureTextFieldProtocol.setBorderColor(.red)
            }
        }
    }
}
