//
//  CardCollectView.swift
//  Tokenizer
//
//  Created by Rodrigo Cámara Robles on 06/09/2024.
//

import SwiftUI
import Tokenizer

struct CardCollectView: View {
    
    @ObservedObject var viewModel: CardCollectViewModel
    
    @State private var text: String = ""
    
    var cardFieldName = Constants.Text.fieldNameCardNumber
    var cardExpirationDateFieldName = Constants.Text.fieldNameCardExpirationDate
    var cvvFieldName = Constants.Text.fieldNameCvv
    var confirmCvvFieldName = Constants.Text.fieldNameConfirmCvv
    
    private var tokenCollector: TokenCollectorProtocol
    
    init(tokenCollector: TokenCollectorProtocol,
         viewModel: CardCollectViewModel = .init()
    ) {
        self.tokenCollector = tokenCollector
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 16.0) {
            TitleView
            VStack(alignment: .leading, spacing: 8.0) {
                SecureCardNumberTextField
                SecureCardExpirationDateTextField
                HStack {
                    SecureCVVNumberTextField
                    SecurecConfirmCVVNumberTextField
                }
            }
            CollectButton
            AreEqualButton
            ResultView
        }
        .padding(.horizontal, 16.0)
        .background(Color.gray.ignoresSafeArea())
        .onDisappear {
            /// Remember to Remove subscribed views when no more needed.
            // tokenCollector.unsubscribeAllViews() or tokenCollector.unsubscribe(fieldName: "")
        }
    }
    
    @ViewBuilder
    private var TitleView: some View {
        Text(Constants.Text.collect)
            .foregroundColor(.black)
            .font(.system(size: 24, weight: .bold))
    }
    
    @ViewBuilder
    private var SecureCardNumberTextField: some View {
        SecureTextFieldSwiftUI(
            viewModel: .init(fieldName: cardFieldName,
                             fieldType: .cardNumber(CardNumberMaskFormatter()),
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.collectCardNumberPlaceholder,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                                borderColor: self.getBorderColor(state: self.viewModel.cardNumberState),
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             )),
            onFieldStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.viewModel.cardNumberState = newState
            },
            tokenCollector: tokenCollector)
        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .leading)
    }
    
    @ViewBuilder
    private var SecureCardExpirationDateTextField: some View {
        SecureTextFieldSwiftUI(
            viewModel: .init(fieldName: cardExpirationDateFieldName,
                             fieldType: .expDate(CardExpirationDateMaskFormatter(dateFormat: .shortYear)),
                             shouldTokenize: false,
                             uiConfig:  .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.collectCardExpirationDatePlaceholder,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 32),
                                borderColor: self.getBorderColor(state: self.viewModel.cardExpirationDateState),
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             )),
            onFieldStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.viewModel.cardExpirationDateState = newState
            },
            tokenCollector: tokenCollector)
        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .leading)
    }
    
    @ViewBuilder
    private var SecureCVVNumberTextField: some View {
        SecureTextFieldSwiftUI(
            viewModel: .init(fieldName: cvvFieldName,
                             fieldType: .cvc,
                             maxLength: 5,
                             uiConfig: .init(
                                textColor: .black,
                                backgroundColor: .white,
                                font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                placeholder: Constants.Text.cvv,
                                cornerRadius: 8.0,
                                padding: .init(top: 8, left: 16, bottom: 8, right: 16),
                                borderColor: self.getBorderColor(state: self.viewModel.cvvState),
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             ),
                             isVolatile: true),
            onFieldStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.viewModel.cvvState = newState
            },
            tokenCollector: tokenCollector)
        
        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .leading)
    }
    
    @ViewBuilder
    private var SecurecConfirmCVVNumberTextField: some View {
        SecureTextFieldSwiftUI(
            viewModel: .init(fieldName: confirmCvvFieldName,
                             fieldType: .cvc,
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
                                borderColor: self.getBorderColor(state: self.viewModel.confirmCvvState),
                                borderWidth: 2.0
                             ),
                             properties: .init(
                                clearButtonMode: .always,
                                keyboardType: .numberPad
                             ),
                             isVolatile: true),
            onFieldStateChange: { newState in
                print("New state with description:\n \(newState.description)")
                self.viewModel.confirmCvvState = newState
            },
            onValidationFailure: { failures in
                print("Failed rules: \(failures)")
                print("")
            },
            tokenCollector: tokenCollector)
        .frame(maxWidth: .infinity, maxHeight: 38, alignment: .leading)
    }
    
    @ViewBuilder
    private var CollectButton: some View {
        HStack {
            Spacer()
            Button(action: {
                collectAction()
            }) {
                Text(Constants.Text.collect)
                    .font(.system(size: 18, weight: .semibold))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    @ViewBuilder
    private var AreEqualButton: some View {
        HStack {
            Spacer()
            Button(action: {
                areEqualAction()
            }) {
                Text(Constants.Text.areEqual)
                    .font(.system(size: 18, weight: .semibold))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 8)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    @ViewBuilder
    private var ResultView: some View {
        VStack(spacing: 8.0) {
            Text(Constants.Text.result)
                .foregroundColor(.black)
                .font(.system(size: 16, weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
            TextEditor(text: $text)
                .border(Color.gray, width: 1)
                .frame(maxHeight: .infinity)
        }
    }
    
    private func collectAction() {
        self.text = Constants.Text.performingRequest
        tokenCollector.collectSubscribedViews { result in
            switch result {
            case .success(let values):
                self.text = values
                    .map { "\($0.key) = \($0.value)" }
                    .joined(separator: "\n")
            case .failure(let error):
                self.text = error.localizedDescription
            }
        }
    }
    
    private func areEqualAction() {
        self.text = tokenCollector.isContentEquals(cvvFieldName, confirmCvvFieldName) ? Constants.Text.areEqueal: Constants.Text.areNotEqueal
    }
    
    private func getBorderColor(state: SecureTextFieldStateProtocol?) -> UIColor {
        guard let state = state as? SecureTextFieldState else {
            return .clear
        }
        if state.isFocused {
            if state.isValid || state.isEmpty {
                return .green
            } else {
                return .red
            }
        } else {
            return state.isValid || state.isEmpty ? .clear : .red
        }
    }
}

struct CardCollectView_Previews: PreviewProvider {
    static var previews: some View {
        CardCollectView(tokenCollector: TokenCollector())
    }
}
