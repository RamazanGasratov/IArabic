//
//  SwiftUIView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

protocol TabItemProtocol: CaseIterable {
    var index: Int { get }
    var image: Image { get }
    var text: String { get }
}

enum Tab: String, TabItemProtocol {
    case library 
    case wordCards
    case dictionary
    
}

extension Tab {
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
    var image: Image {
        switch self {
        case.library: return Image(systemName: "building.columns")
        case.wordCards: return Image(systemName: "menucard")
        case.dictionary: return Image(systemName: "character.book.closed")
        }
    }
    
    var text: String {
        switch self {
        case.library: return "Библиотека"
        case.wordCards: return "Карточки"
        case.dictionary: return "Словарь"
        }
    }
}
