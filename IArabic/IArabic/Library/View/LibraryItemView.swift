//
//  LibraryItemView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 28.02.2024.
//

import Foundation
import SwiftUI

struct LibraryItemView: View {
    var word: Words
    
    var body: some View {
        VStack(spacing: 40) {
            ImageManager.loadImage(from: word.imageMain)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            VStack(spacing: 10) {
                Text(word.translate ?? "")
                    .font(.montserrat(.bold, size: 22))
                    .lineLimit(1)
                Text(word.title ?? "" )
                    .font(.montserrat(.regular, size: 18))
                    .lineLimit(1)
            }
            .foregroundColor(Color.custom.black)
            .padding(.horizontal, 5)
        }
        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .background(Color.custom.white)
    }
}
//
//#Preview {
//    LibraryItemView(word: WordsLib(titleIMage: "", rusWord: "Русс", arabWords: "араб"))
//}
