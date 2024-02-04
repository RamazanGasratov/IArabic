//
//  CardWordsModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 20.01.2024.
//

import Foundation

struct CardWords: Identifiable, Hashable {
    let id: UUID
    let wordArabic: String
    let wordTranslate: String
    let imageURL: String
    
    init(wordArabic: String, wordTranslate: String, imageURL: String) {
        self.id = UUID()
        self.wordArabic = wordArabic
        self.wordTranslate = wordTranslate
        self.imageURL = imageURL
    }
}

struct WordsData {
    static let getAllWords: [CardWords] = [
        .init(wordArabic: "الأم", wordTranslate: "Мама", imageURL: "дочь"),
        .init(wordArabic: "ابن", wordTranslate: "сын", imageURL: "сын"),
        .init(wordArabic: "منزل", wordTranslate: "дом", imageURL: "дом"),
        .init(wordArabic: "منزل", wordTranslate: "дом", imageURL: "дом"),
        .init(wordArabic: "منزل", wordTranslate: "дом", imageURL: "дом"),
        .init(wordArabic: "منزل", wordTranslate: "дом", imageURL: "дом"),
        .init(wordArabic: "منزل", wordTranslate: "дом", imageURL: "дом"),
        .init(wordArabic: "ابن", wordTranslate: "сын", imageURL: "сын"),
        .init(wordArabic: "ابن", wordTranslate: "сын", imageURL: "сын"),
        .init(wordArabic: "ابن", wordTranslate: "сын", imageURL: "сын"),
    ]
}
