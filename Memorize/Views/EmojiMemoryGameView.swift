//
//  EmojiMemoryGameView.swift
//  Memorize - Vue
//
//  Created by Gabriel Caron on 2021-02-08.
//

import SwiftUI

let game = EmojiMemoryGame()

struct EmojiMemoryGameView: View {
    // Accès à la vue-modèle
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        // Choisir une carte
        VStack {
            Grid(items: viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .padding(10)
            .foregroundColor(Color.orange)
            Button(action: {
                // animation explicite
                withAnimation(.easeInOut) {
                    viewModel.resetGame()
                }
            }, label: { Text("Nouvelle partie")})
        }
        
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double  = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    // Si deux cartes sont jumelées
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                startBonusTimeAnimation()
                            }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                .padding(10).opacity(0.4)
                .transition(.scale)
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 :0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
        
    
    // MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * 0.7
    }
    
}









// Sert pour donner un aperçu dans Xcode

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}

