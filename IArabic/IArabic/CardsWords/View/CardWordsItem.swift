//
//  CardWordsItem.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 04.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardWordsItem: View {
    var textTitle: String?
    var textTranslate: String?
    var mainImage: Data?
    var assImage: Data?

    var body: some View {
        VStack(spacing: 35) {
            titleAndTranslateText
            
            imageMain
                .padding(.horizontal, 20)
                .padding()
        }
        .background(Color.custom.white)
        .shadow(radius: 0)
    }
    
        var titleAndTranslateText: some View {
            VStack(spacing: 6) {
                Text(textTranslate ?? "Арабское")
                    .font(.montserrat(.semibold, size: 30))
                Text(textTitle ?? "Перевод")
                    .font(.montserrat(.light, size: 18))
            }
       }
    
        var imageMain: some View {
            VStack {
                Image(uiImage: UIImage(data: mainImage ?? Data()) ?? UIImage())
                    .resizable()
                    .frame(width: 281, height: 208)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Image(uiImage: UIImage(data: assImage ?? Data()) ?? UIImage())
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .frame(width: 263, height: 183)
            }
        }
     
}

#Preview {
    CardWordsItem()
}

