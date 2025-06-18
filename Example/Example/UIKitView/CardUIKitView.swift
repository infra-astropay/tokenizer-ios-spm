//
//  CardUIKitView.swift
//  TokenizerPOC
//
//  Created by Rodrigo Cámara Robles on 12/06/2024.
//

import UIKit
import Tokenizer

final class CardUIKitView: UIViewController {    
    
    private var tokenRevealer: TokenRevealerProtocol
    private var isLabelShown = false
    private var copyTextToClipBoard = false
    
    private lazy var titleView: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.show
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardContentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Constants.Color.cardBackgroundColor
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cardNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.cardHolderName
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cardValueLabel: SecureLabelProtocol = {
        let label = ComponentBuilder.createSecureLabel(
            token: "tok_test_",
            viewModel: .init(
                textColor: .black,
                font: UIFont(name: "Helvetica-Bold", size: 18),
                placeholder: Constants.Text.cardNumberPlaceholder,
                contentPath: "card.number",
                regexPattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
                regexTemplate: "$1 $2 $3 $4"),
            copied: {},
            tokenRevealer: tokenRevealer)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 16
        return view
    }()
    
    private lazy var validDateStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var cvvStackView: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private lazy var validDateLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.validUntil
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var validDateValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.expireDate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cvvLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Constants.Text.cvv
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cvvValueLabel: SecureLabelProtocol = {
        return ComponentBuilder.createSecureLabel(
            viewModel: .init(textColor: .black,
                             font: UIFont(name: "Helvetica-Bold", size: 18),
                             placeholder: Constants.Text.cvvPlaceholder,
                             contentPath: "card.cvv"),
            tokenRevealer: tokenRevealer)
    }()
    
    private lazy var revealButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Text.reveal
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .medium
        configuration.titlePadding = 8
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.addTarget(self, action: #selector(toggleLabelVisibility), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var copyButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = Constants.Text.copy
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .blue
        configuration.cornerStyle = .medium
        configuration.titlePadding = 8
        
        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.isEnabled = self.isLabelShown
        button.addTarget(self, action: #selector(copyText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.Text.textFieldPlaceholder
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    init(tokenRevealer: TokenRevealerProtocol) {
        self.tokenRevealer = tokenRevealer
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
        cardValueLabel.setToken(Constants.Token.cardToken)
        cvvValueLabel.setToken(Constants.Token.cvvToken)
    }
    
    private func setUpView() {
        view.addSubview(titleView)
        view.addSubview(cardContentView)
        view.addSubview(cardNameLabel)
        view.addSubview(cardValueLabel)
        view.addSubview(horizontalStack)
        view.addSubview(revealButton)
        view.addSubview(copyButton)
        view.addSubview(textField)
        
        horizontalStack.addArrangedSubview(validDateStackView)
        horizontalStack.addArrangedSubview(cvvStackView)
        validDateStackView.addArrangedSubview(validDateLabel)
        validDateStackView.addArrangedSubview(validDateValueLabel)
        cvvStackView.addArrangedSubview(cvvLabel)
        cvvStackView.addArrangedSubview(cvvValueLabel)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cardContentView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            cardContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            cardNameLabel.topAnchor.constraint(equalTo: cardContentView.safeAreaLayoutGuide.topAnchor, constant: 100),
            cardNameLabel.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor, constant: 16),
            cardNameLabel.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor, constant: -16),
            
            cardValueLabel.topAnchor.constraint(equalTo: cardNameLabel.bottomAnchor, constant: 8),
            cardValueLabel.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            cardValueLabel.trailingAnchor.constraint(equalTo: cardNameLabel.trailingAnchor),
            
            horizontalStack.topAnchor.constraint(equalTo: cardValueLabel.bottomAnchor, constant: 16),
            horizontalStack.leadingAnchor.constraint(equalTo: cardNameLabel.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(lessThanOrEqualTo: cardNameLabel.trailingAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: -16),
            
            revealButton.topAnchor.constraint(equalTo: cardContentView.bottomAnchor, constant: 16),
            revealButton.trailingAnchor.constraint(equalTo: copyButton.leadingAnchor, constant: -16),
            
            copyButton.topAnchor.constraint(equalTo: revealButton.topAnchor),
            copyButton.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor)
        ])
    }
    
    @objc private func toggleLabelVisibility() {
        isLabelShown.toggle()
        if isLabelShown {
            revealButton.isEnabled = false
            tokenRevealer.revealSubscribedViews() { result in
                switch result {
                case .success:
                    print("Success - Data revealed")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.revealButton.isEnabled = true
                self.copyButton.isEnabled = true
            }
        } else {
            copyButton.isEnabled = false
            cardValueLabel.hideData()
            cvvValueLabel.hideData()
        }
        let buttonTitle = isLabelShown ? Constants.Text.hide : Constants.Text.reveal
        revealButton.setTitle(buttonTitle, for: .normal)
    }
    
    @objc private func copyText() {
        cardValueLabel.copyText()
        print("card.number coppied to pasteboard")
    }
}
