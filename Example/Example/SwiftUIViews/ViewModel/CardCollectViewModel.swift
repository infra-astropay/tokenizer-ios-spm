//
//  CardCollectViewModel.swift
//  Example
//
//  Created by Rodrigo Cámara Robles on 17/09/2024.
//

import Tokenizer

final class CardCollectViewModel: ObservableObject {    
    @Published var cardNumberState: SecureTextFieldStateProtocol?
    @Published var cardExpirationDateState: SecureTextFieldStateProtocol?
    @Published var cvvState: SecureTextFieldStateProtocol?
    @Published var confirmCvvState: SecureTextFieldStateProtocol?
}
