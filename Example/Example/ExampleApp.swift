//
//  ExampleApp.swift
//  Example
//
//  Created by Rodrigo Cámara Robles on 02/07/2024.
//

import SwiftUI
import Tokenizer

@main
struct ExampleApp: App {
    
    private var tokenRevealerForSwiftUI: TokenRevealerProtocol = TokenRevealer()
    private var tokenRevealerForUIKit: TokenRevealerProtocol = TokenRevealer()
    
    private var tokenCollectorForSwiftUI: TokenCollectorProtocol = TokenCollector()
    private var tokenCollectorForUIKit: TokenCollectorProtocol = TokenCollector()
    
    init() {
        TokenizerConfig.shared.initialize(
            accessToken: Constants.Token.accessToken,
            environment: .sandbox)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CardCollectView(tokenCollector: tokenCollectorForSwiftUI)
                    .tabItem {
                        Label("SwiftUI Collect", systemImage: "1.square.fill")
                    }
                CardCollectUIKitViewRepresentable(tokenCollector: tokenCollectorForUIKit)
                    .tabItem {
                        Label("UIKit Collect", systemImage: "2.square.fill")
                    }
                CardView(tokenRevealer: tokenRevealerForSwiftUI)
                    .tabItem {
                        Label("SwiftUI Show", systemImage: "3.square.fill")
                    }
                CardUIKitViewRepresentable(tokenRevelear: tokenRevealerForUIKit)
                    .tabItem {
                        Label("UIKit Show", systemImage: "4.square.fill")
                    }
            }
        }
    }
}
