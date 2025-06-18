//
//  CardUIKitViewRepresentable.swift
//  TokenizerPOC
//
//  Created by Rodrigo Cámara Robles on 12/06/2024.
//

import SwiftUI
import Tokenizer

struct CardUIKitViewRepresentable: UIViewControllerRepresentable {    
    
    private var tokenRevelear: TokenRevealerProtocol
    
    init(tokenRevelear: TokenRevealerProtocol) {
        self.tokenRevelear = tokenRevelear
    }
    
    func makeUIViewController(context: Context) -> CardUIKitView {
        return CardUIKitView(tokenRevealer: tokenRevelear)
    }
    
    func updateUIViewController(_ uiViewController: CardUIKitView, context: Context) {}
}
