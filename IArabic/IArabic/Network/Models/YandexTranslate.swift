//
//  YandexTranslateApi.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 06.03.2024.
//

import Foundation

struct AuthModel: Encodable {
    let yandexPassportOauthToken: String
}

struct ParsingAuthData: Decodable {
    let iamToken: String?
}

struct TranslateModel: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let text: String?                 //само слово перевода
    let detectedLanguageCode: String? //prefix
}
