//
//  CardsWordsView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI


class CardViewModel: ObservableObject {
  @Published var cards = WordsData.getAllWords
}

struct CardsWordsRow: View {
    @State private var screenWith: CGFloat = 0
    @State private var cardHeight: CGFloat = 0
    
    let widthScale = 0.80
    let cardAspectRatio = 1.75
    
    @ObservedObject var vm = CardViewModel()
    
    @State var activeCardIndex = 1
    @State var draggOffset: CGFloat = 1
    
    var body: some View {
   
        GeometryReader { reader in
            ZStack {
                ForEach(vm.cards.indices, id: \.self) { index in
                    
                    CardWordsItem(textTitle: vm.cards[index].wordArabic, textTranslate: vm.cards[index].wordTranslate, image: vm.cards[index].imageURL)
                    
                        .frame(width: screenWith * widthScale, height: cardHeight)
                        .background(Color.custom.white)
                        .overlay {
                            Color.white.opacity( 1 - cardScale(for: index, proportion: 0.3))
                        }
                        .cornerRadius(20)
//                        .offset(x: cardOffset(for: index))
//                        .scaleEffect(x: cardScale(for: index), y: cardScale(for: index))
//                        .zIndex(-Double(index))
//                        .gesture(
//                        DragGesture()
//                                .onChanged { value in
//                                    self.draggOffset = value.translation.width
//                                }.onEnded{ value in
//                                    let threshold = screenWith * 0.2
//                                    
//                                    withAnimation {
//                                        if value.translation.width < -threshold {
//                                            activeCardIndex = min(activeCardIndex + 1, vm.cards.count - 1)
//                                        } else if value.translation.width > threshold  {
//                                            activeCardIndex = max(activeCardIndex - 1, 0)
//                                        }
//                                    }
//                                    
//                                    withAnimation {
//                                        draggOffset = 0
//                                    }
//                                }
//                        )
//                    }
            
//            .shadow(radius: 7)
//            .onAppear {
//                print("CardsWordsRow appears")
//                screenWith = reader.size.width
//                cardHeight = screenWith * widthScale * cardAspectRatio
            }
//            .onDisappear {
//                print("CardsWordsRow disappears")
            }
            
//            .offset(x: 16, y: 30)
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
    CardWordsView()
}


struct CardsWordsRow2: View {
    
    @State var currentIndex: Int = 0
    
    @State var words = WordsData.getAllWords
    
    var body: some View {
        VStack(spacing: 15) {
            SnapCarousel(index: $currentIndex, items: words) { word in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    CardWordsItem(textTitle: word.wordTranslate, textTranslate: word.wordArabic, image: word.imageURL)
                        .frame(width: size.width)
                        .cornerRadius(10)
                }
            }
            .padding(.vertical, 40)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            words
        }
    }
}


struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    //Properties..
    var spacing: CGFloat
    var tralligSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        
        self.list = items
        self.spacing = spacing
        self.tralligSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        GeometryReader { proxy in
            
            //Setting correct Width for snap Carousel...
            let with = proxy.size.width - (tralligSpace - spacing)
            let adjustMentWidth = (tralligSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                     content(item)
                        .frame(width: max(proxy.size.width - tralligSpace, 0))
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -with) + (currentIndex != 0 ?  adjustMentWidth : 0)  + offset)
            .gesture(
                
            DragGesture()
                .updating($offset, body: { value, out, _ in
                    
                    
                    out = value.translation.width
                })
                .onEnded({ value in
                    
                    
                    // Updating current index..
                    let offsetX = value.translation.width
                    
                    let proggress = -offsetX / with
                    
                    let roundIndex = proggress.rounded()
                    
                    currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    
                    
                    currentIndex = index
                })
                .onChanged({ value in
                    let offsetX = value.translation.width
                    
                    let proggress = -offsetX / with
                    
                    let roundIndex = proggress.rounded()
                    
                    index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                })
            )
        }
        // Animation when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}
