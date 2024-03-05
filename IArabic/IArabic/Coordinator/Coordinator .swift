//
//  Coordinator .swift
//  IArabic
//
//  Created by Ramazan Gasratov on 21.02.2024.
//
import SwiftUI

enum Page: String, Identifiable {
    case library
    case wordCards
    case dictionary
    
    var id: String {
        self.rawValue
    }
}

enum Sheet: String, Identifiable {
    case newWord
    case editWord
    
    var id: String {
        self.rawValue
    }
}

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var editingWord: Words?
    @ObservedObject private var coreDataViewModel = CoreDataViewModel()
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }

    func dismissSheet() {
        self.sheet = nil
    }

    // Метод для открытия экрана редактирования с передачей данных слова
       func editWord(_ word: Words? = nil) {
           self.editingWord = word
           self.sheet = .editWord
       }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .library :
            LibraryView()
      
        case .wordCards :
            CardWordsView()
            
        case .dictionary :
            DictionaryView()
        }
    }
//    
//    @ViewBuilder
//    func build(sheet: Sheet) -> some View {
//        switch sheet {
//        case .newWord:
//            NavigationStack {
////                NewWordView()
////                    .environmentObject(coreDataViewModel)
//            }
//        case .editWord:
//            NavigationStack {
//                // Проверяем, что у нас есть слово для редактирования
//                if let editingWord = editingWord {
//                    NewWordView(editingWord: editingWord) // Передаем слово во View
//                        .environmentObject(coreDataViewModel)
//                }
//            }
//        }
//    }
}
