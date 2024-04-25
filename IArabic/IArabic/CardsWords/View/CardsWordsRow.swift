//
//  CardsWordsView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

struct CardWordsRow: View {
    
    @State var currentIndex: Int = 0
    
    var words: FetchedResults<Words>
    
    var body: some View {
        VStack(spacing: 15) {
            SnapCarousel(index: $currentIndex, items: words.reversed()) { word in
                
                GeometryReader { proxy in
                    let size = proxy.size
        
                    CardWordsItem(textTitle: word.title, textTranslate: word.translate, imageMain: word.imageMain, imageAssociate: word.associatImage)
                        .frame(width: size.width)
                        .cornerRadius(20)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
//
//#Preview {
//    CardWordsRow(vmCoreData: CoreDataViewModel())
//}
