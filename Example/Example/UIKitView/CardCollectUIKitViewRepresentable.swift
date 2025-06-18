//
//  CardCollectUIKitViewRepresentable.swift
//  Tokenizer
//
//  Created by Rodrigo Cámara Robles on 06/09/2024.
//

import SwiftUI
import Tokenizer

struct CardCollectUIKitViewRepresentable: UIViewControllerRepresentable {    
    
    private var tokenCollector: TokenCollectorProtocol
    
    init(tokenCollector: TokenCollectorProtocol) {
        self.tokenCollector = tokenCollector
    }
    
    func makeUIViewController(context: Context) -> CardCollectUIKitView {
        return CardCollectUIKitView(tokenCollector: tokenCollector)
    }
    
    func updateUIViewController(_ uiViewController: CardCollectUIKitView, context: Context) {
        
    }
}
