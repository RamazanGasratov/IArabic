//
//  CardsWordsView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

struct CardsWordsRow: View {
    @State private var screenWith: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    let widthScale = 0.80
    let cardAspectRatio = 1.75
    
    let cards = WordsData.getAllWords
    
    @State var activeCardIndex = 0
    @State var draggOffset: CGFloat = 0
    
    var body: some View {
   
        GeometryReader { reader in
            ZStack {
                ForEach(cards.indices, id: \.self) { index in
                    
                    CardWordsItem(textTitle: cards[index].wordArabic, textTranslate: cards[index].wordTranslate, image: cards[index].imageURL)
                    
                        .frame(width: screenWith * widthScale, height: cardHeight)
                        .background(Color.custom.white)
                        .overlay {
                            Color.white.opacity( 1 - cardScale(for: index, proportion: 0.3))
                        }
                        .cornerRadius(20)
                        .offset(x: cardOffset(for: index))
                        .scaleEffect(x: cardScale(for: index), y: cardScale(for: index))
                        .zIndex(-Double(index))
                        .gesture(
                        DragGesture()
                                .onChanged { value in
                                    self.draggOffset = value.translation.width
                                }.onEnded{ value in
                                    let threshold = screenWith * 0.2
                                    
                                    withAnimation {
                                        if value.translation.width < -threshold {
                                            activeCardIndex = min(activeCardIndex + 1, cards.count - 1)
                                        } else if value.translation.width > threshold  {
                                            activeCardIndex = max(activeCardIndex - 1, 0)
                                        }
                                    }
                                    
                                    withAnimation {
                                        draggOffset = 0
                                    }
                                }
                        )
                    }
            }
            .shadow(radius: 7)
            .onAppear {
                screenWith = reader.size.width
                cardHeight = screenWith * widthScale * cardAspectRatio
            }
            .offset(x: 16, y: 30)
        }
    }
    
    func cardOffset(for index: Int) -> CGFloat {
        let adjustedIndex = index - activeCardIndex
        
        let cardSpacing: CGFloat = 60 / cardScale(for: index)
        let initalOffset = cardSpacing * CGFloat(adjustedIndex)
        
        let progress = min(abs(draggOffset)/(screenWith/2), 1)
        let maxCardMovemet = cardSpacing
        
        if adjustedIndex < 0 {
            if draggOffset > 0 && index == activeCardIndex - 1 {
               
                let distanceToMove = (initalOffset + screenWith) * progress
                
                return -screenWith + distanceToMove
            } else {
                return -screenWith
            }
        } else if index > activeCardIndex {
           let diastanceToMove = progress * maxCardMovemet
            return initalOffset - (draggOffset < 0 ? diastanceToMove : -diastanceToMove)
        } else {
            if draggOffset < 0 {
                return draggOffset
            } else {
                let diastanceToMove = maxCardMovemet * progress
                return initalOffset - (draggOffset < 0 ? diastanceToMove : -diastanceToMove)
            }
        }
    }
    
    func cardScale(for index: Int, proportion: CGFloat = 0.2) -> CGFloat {
        let adjustedIndex = index - activeCardIndex
        if index > activeCardIndex {
            let progress = min(abs(draggOffset)/(screenWith/2), 1)
            return 1 - proportion * CGFloat(adjustedIndex) + (draggOffset < 0 ? proportion * progress : -proportion * progress)
        }
        
        
       return 1
    }
}

#Preview {
    CardsWordsRow()
}
