//
//  DictionaryViewModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 25.02.2024.
//

import Foundation
import Combine

class DictionaryViewModel: ObservableObject {
    @Published var items: [DictionaryItem] = []
    @Published var filteredItems: [DictionaryItem] = []
    @Published var searchText = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        loadJsonData()
        
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .map { searchText in
                if searchText.isEmpty {
                    return self.items
                } else {
                    return self.items.filter { item in
                        item.rusText.lowercased().contains(searchText.lowercased()) ||
                        item.arText.contains(searchText)
                    }
                }
                
            }
            .assign(to: \.filteredItems, on: self)
            .store(in: &cancellables)
    }
    
    func loadJsonData() {
        guard let url = Bundle.main.url(forResource: "Dictionary", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([DictionaryItem].self, from: data)
            DispatchQueue.main.async {
                self.items = jsonData
                self.filteredItems = jsonData
            }
        } catch {
            print(error)
        }
    }
}
