//
//  Constants.swift
//  TokenizerPOC
//
//  Created by Rodrigo Cámara Robles on 26/06/2024.
//

import UIKit

struct Constants {
    struct Text {
        static let show = "SHOW"
        static let result = "Result"
        static let reveal = "REVEAL"
        static let collect = "COLLECT"
        static let hide = "HIDE"
        static let copy = "COPY"
        static let areEqual = "CVV ARE EQUAL"
        static let cardHolderName = "RODRIGO CAMARA ROBLES"
        static let cardNumberPlaceholder = "**** **** **** ****"
        static let collectCardNumberPlaceholder = "Card number"
        static let collectCardExpirationDatePlaceholder = "MM/YY"
        static let validUntil = "VALIDO HASTA"
        static let expireDate = "12/29"
        static let cvv = "CVV"
        static let confirmCvv = "Confirm CVV"
        static let cvvPlaceholder = "***"
        static let fieldNameCardNumber = "cardNumber"
        static let fieldNameCardExpirationDate = "cardExpirationDate"
        static let fieldNameCvv = "cvv"
        static let fieldNameConfirmCvv = "confirmCvv"
        static let textFieldPlaceholder = "Enter copied text"
        static let performingRequest = "Performing request..."
        static let areEqueal = "Compared fields ARE EQUAL"
        static let areNotEqueal = "Compared fields ARE NOT EQUAL"
        static let imageCircleFill = "xmark.circle.fill"
    }
    
    struct Color {
        static let cardBackgroundColor = UIColor(red: 0.42, green: 0.05, blue: 0.68, alpha: 1.00)
    }
    
    struct ValidationPattern {
        static let fourDigitNumberPattern = "^(?!.*?(?:0123|1234|2345|3456|4567|5678|6789|9876|8765|7654|6543|5432|4321|(\\d)\\1\\1\\1))\\d{4}$"
        static let fourDigitNumberPatternMessage = "Four Digit Number Pattern"
    }
    
    struct Token {
        static let accessToken = """
        """
        static let cardToken = ""
        static let cvvToken = ""
    }
}
