//
//  NewWordViewModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 10.02.2024.
//

import SwiftUI
import Combine

final class NewWordViewModel: ObservableObject {
    @Published var arabWord: String = ""
    private var cancellables = Set<AnyCancellable>() // Хранит подписки
    
    func translate(text: String, prefix: String) {
        // Предполагаем, что у Network.shared.translate теперь есть возвращаемый тип AnyPublisher<String, Error>
        Network.shared.translate(text: text, prefix: prefix)
            .receive(on: DispatchQueue.main) // Чтобы обновлять UI на главном потоке
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Ничего не делаем, если все прошло успешно
                case .failure(let error):
                    print(error) // Обрабатываем ошибку
                }
            }, receiveValue: { [weak self] translate in
                self?.arabWord = translate // Получаем перевод и обновляем значение
                print("Перевод выполнен")
            })
            .store(in: &cancellables) // Храним подписку, чтобы она не была отменена автоматически
    }
}
