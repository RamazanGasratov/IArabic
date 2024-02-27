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

enum FullScreenCover: String, Identifiable {
    case newWord
    case editWord // Для экрана редактирования слова
    
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
    @Published var fullScreenCover: FullScreenCover?
    @Published var sheet: Sheet?
    @Published var editingWord: Words?
    
    // Переход на экрана
    func push(_ page: Page) {
        path.append(page)
    }
    
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    // Закрытие экрана и переход на экран родителя
    func pop() {
        path.removeLast()
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    // Метод для открытия экрана редактирования с передачей данных слова
       func editWord(_ word: Words) {
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
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .newWord:
            NavigationStack {
                NewWordView()
                    .environmentObject(CoreDataViewModel())
            }
        case .editWord:
            NavigationStack {
                // Проверяем, что у нас есть слово для редактирования
                if let editingWord = editingWord {
                    NewWordView(editingWord: editingWord) // Передаем слово во View
                        .environmentObject(CoreDataViewModel())
                }
            }
        }
    }
    
    // Изменяем метод build для обработки нового случая
      @ViewBuilder
      func build(fullScreenCover: FullScreenCover) -> some View {
          switch fullScreenCover {
          case .newWord:
              NavigationStack {
                  NewWordView()
                      .environmentObject(CoreDataViewModel())
              }
          case .editWord:
              NavigationStack {
                  // Проверяем, что у нас есть слово для редактирования
                  if let editingWord = editingWord {
                      NewWordView(editingWord: editingWord) // Передаем слово во View
                          .environmentObject(CoreDataViewModel())
                  }
              }
          }
      }
}
