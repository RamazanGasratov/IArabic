//
//  CardWordsItem.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 04.02.2024.
//

import SwiftUI

struct CardWordsItem: View {
    var textTitle: String?
    var textTranslate: String?
    
    var image: String?

    var body: some View {
        VStack(spacing: 10) {
            titleAndTranslateText
            
            imageMain
                .padding(.horizontal, 20)
                .padding()
        }
        .background(Color.red)
        .shadow(radius: 14)
    }
    
    var titleAndTranslateText: some View {
        VStack {
            Text(textTranslate ?? "Арабское")
                .font(.title)
            Text(textTitle ?? "Перевод")
                .font(.footnote)
        }
        .padding()
   }
    
    var imageMain: some View {
        VStack {
            Image(image ?? "сын")
                .resizable()
                .frame(height: 208)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Image(image ?? "сын")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 195)
                .padding(.horizontal, 25)
                
        } 
    }
     
}

#Preview {
    CardWordsItem()
}
