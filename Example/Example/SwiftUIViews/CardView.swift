//
//  CardView.swift
//  TokenizerPOC
//
//  Created by Rodrigo Cámara Robles on 12/06/2024.
//

import SwiftUI
import Tokenizer

struct CardView: View {
    
    @State private var isLabelShown = false
    @State private var isRevealSuccess = false
    @State private var isRevealing = false
    @State private var shouldCopyText = false
    @State private var shouldHideData = false
    @State private var copiedText = ""
    
    private var tokenRevealer: TokenRevealerProtocol
    private var cardToken: String = Constants.Token.cardToken
    private var cvvToken: String = Constants.Token.cvvToken
    
    init(tokenRevealer: TokenRevealerProtocol) {
        self.tokenRevealer = tokenRevealer
    }
    
    var body: some View {
        VStack(spacing: 4.0) {
            TitleView
            CardView
            RevealCopyButtons
            CustomTextField
            Spacer()
        }
        .background(Color.gray.ignoresSafeArea())
    }
    
    @ViewBuilder
    private var TitleView: some View {
        Text(Constants.Text.show)
            .foregroundColor(.black)
            .font(.system(size: 24, weight: .bold))
    }
    
    @ViewBuilder
    private var CardView: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(Constants.Text.cardHolderName)
                    .foregroundColor(.white)
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureLabelSwiftUI(
                    token: cardToken,
                    viewModel: .init(
                        textColor: .black,
                        font: UIFont(name: "Helvetica-Bold", size: 18),
                        placeholder: Constants.Text.cardNumberPlaceholder,
                        contentPath: "card.number",
                        regexPattern: "(\\d{4})(\\d{4})(\\d{4})(\\d{4})",
                        regexTemplate: "$1 $2 $3 $4"),
                    shouldHideData: shouldHideData,
                    shouldCopyText: shouldCopyText,
                    copyWithFormat: false,
                    copied: {
                        print("card.number coppied to pasteboard")
                        shouldCopyText = false
                    },
                    tokenRevealer: tokenRevealer)
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding([.leading, .trailing], 16)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.Text.validUntil)
                        .foregroundColor(.white)                        
                    Text(Constants.Text.expireDate)
                        .foregroundColor(.black)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(Constants.Text.cvv)
                        .foregroundColor(.white)                        
                    SecureLabelSwiftUI(
                        token: cvvToken,
                        viewModel: .init(
                            textColor: .black,
                            font: UIFont(name: "Helvetica-Bold", size: 18),
                            placeholder: Constants.Text.cvvPlaceholder,
                            contentPath: "card.cvv"),
                        shouldHideData: shouldHideData,
                        tokenRevealer: tokenRevealer)
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding([.leading, .trailing, .bottom], 16)
        }
        .frame(maxWidth: .infinity)
        .background(Color(Constants.Color.cardBackgroundColor))
        .cornerRadius(16)
        .padding([.leading, .trailing, .top], 16)
    }
    
    @ViewBuilder
    private var RevealCopyButtons: some View {
        HStack(spacing: 16) {
            Spacer()
            Button(action: {
                revealHideAction()
            }) {
                Text(isLabelShown ? Constants.Text.hide : Constants.Text.reveal)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(!isRevealing ? .blue : .secondary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }.disabled(isRevealing)
            
            Button(action: {
                copyText()
            }) {
                Text(Constants.Text.copy)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(isRevealSuccess ? .blue : .secondary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isRevealSuccess)
        }
        .padding([.leading, .trailing, .top], 16)
    }
    
    @ViewBuilder
    private var CustomTextField: some View {
        TextField(Constants.Text.textFieldPlaceholder, text: $copiedText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .overlay(
                Button(
                    action: {
                        self.copiedText = ""
                    }) {
                        Image(systemName: Constants.Text.imageCircleFill)
                            .foregroundColor(.gray)
                            .padding(.trailing, 24)
                    }
                    .opacity(copiedText.isEmpty ? 0 : 1),
                alignment: .trailing
            )
    }
    
    private func revealHideAction() {
        isLabelShown.toggle()
        isRevealSuccess = false
        if isLabelShown {
            isRevealing = true
            shouldHideData = false
            tokenRevealer.revealSubscribedViews { result in
                switch result {
                case .success:
                    print("Success - Data revealed")
                    isRevealSuccess = true
                case .failure(let error):
                    print(error.localizedDescription)
                }
                isRevealing = false
            }   
        } else {
            shouldHideData = true
        }
    }
    
    private func copyText() {
        shouldCopyText = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(tokenRevealer: TokenRevealer())
    }
}
