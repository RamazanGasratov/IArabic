//
//  DictionaryViewModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 25.02.2024.
//

import Foundation
import Combine

import Combine
import Foundation

// Data Service
protocol DictionaryDataServiceProtocol {
    func fetchDictionary(forCategory category: Category) -> AnyPublisher<[DictionaryItem], Error>
}

class DictionaryDataService: DictionaryDataServiceProtocol {
    func fetchDictionary(forCategory category: Category) -> AnyPublisher<[DictionaryItem], Error> {
        guard let url = Bundle.main.url(forResource: category.id, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        let decoder = JSONDecoder()
        return Just(data)
            .decode(type: [DictionaryItem].self, decoder: decoder)
            .mapError { _ in URLError(.cannotParseResponse) }
            .eraseToAnyPublisher()
    }
}

// ViewModel
class DictionaryViewModel: ObservableObject {
    @Published var items: [DictionaryItem] = []
    @Published var filteredItems: [DictionaryItem] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category? {
        didSet { loadItems() }
    }
    
    private var initialCategoryID = "OneMed"
    
    var cancellables: Set<AnyCancellable> = []
    private let dataService: DictionaryDataServiceProtocol
    
    init(dataService: DictionaryDataServiceProtocol = DictionaryDataService()) {
        self.dataService = dataService
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map(filterItems)
            .assign(to: \.filteredItems, on: self)
            .store(in: &cancellables)
        
        self.selectedCategory = Category(id: initialCategoryID, name: "первый том")
    }
    
    private func filterItems(_ searchText: String) -> [DictionaryItem] {
        if searchText.isEmpty {
            return self.items
        } else {
            return self.items.filter { item in
                item.rusText.lowercased().contains(searchText.lowercased()) ||
                item.arText.contains(searchText)
            }
        }
    }
    
    private func loadItems() {
        guard let category = selectedCategory else { return }
        
        dataService.fetchDictionary(forCategory: category)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] newItems in
                self?.items = newItems
                self?.filteredItems = newItems
            })
            .store(in: &cancellables)
    }
}
