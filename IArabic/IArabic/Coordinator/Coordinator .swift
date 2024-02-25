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
    
    var id: String {
        self.rawValue
    }
}

final class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?
    
    // Переход на экрана
    func push(_ page: Page) {
        path.append(page)
    }
    
    // Закрытие экрана и переход на экран родителя
    func pop() {
        path.removeLast()
    }
    
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
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
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .newWord:
            NavigationStack {
                NewWordView()
                    .environmentObject(CoreDataViewModel())
            }
        }
    }
}
