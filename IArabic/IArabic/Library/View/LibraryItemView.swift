//
//  LibraryItemView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 28.02.2024.
//

import Foundation
import SwiftUI

struct LibraryItemView: View {
    var word: Words // Предполагается, что у вас есть такой тип данных
       @Binding var selectedWord: Words? // Добавлено
       @Binding var presenNewWords: Bool // Добавлено
    var body: some View {
        Button(action: {
            self.selectedWord = word // Устанавливаем выбранное слово
                      self.presenNewWords = true 
        }) {
            VStack(spacing: 10) {
                ImageManager.loadImage(from: word.imageMain)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 85, height: 85)
                    .clipShape(Circle())
                
                VStack(spacing: 5) {
                    Text(word.translate ?? "")
                        .font(.montserrat(.bold, size: 16))
                        .lineLimit(1)
                    Text(word.title ?? "" )
                        .font(.montserrat(.regular, size: 12))
                        .lineLimit(1)
                }
                .foregroundColor(Color.custom.black)
                .padding(.horizontal, 5)
            }
            .frame(width: 115, height: 170)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}
