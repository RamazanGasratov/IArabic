//
//  Coordinator .swift
//  IArabic
//
//  Created by Ramazan Gasratov on 21.02.2024.
//
import SwiftUI

enum Page: String, Identifiable {
    case newWord
    case cardWords
    
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
    
    @StateObject private var coordinator = Coordinator()
    
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
        case .newWord:
            NewWordView()
        case .cardWords:
            CardWordsView()
                .environmentObject(CoreDataViewModel())
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .newWord:
            NavigationStack {
                NewWordView()
            }
        }
    }
}
