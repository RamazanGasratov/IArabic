//
//  SnapCarousel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 10.02.2024.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    //Properties..
    var spacing: CGFloat
    var tralligSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 50, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        
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
