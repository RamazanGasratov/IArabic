//
//  DictionaryView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 12.02.2024.
//

import SwiftUI

struct DictionaryView: View {
    @StateObject private var viewModel = DictionaryViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.items) { item in
                                            DictionaryViewItem(rusText: item.rusText, arText: item.arText)
                                        }
                    
                }
            }
            .navigationTitle("Топ слов")
        }
    }
}

#Preview {
    DictionaryView()
}


struct DictionaryViewItem: View {
    var rusText: String
    var arText: String
    
    var body: some View {
        HStack {
            Text(rusText)
                .font(.montserrat(.medium, size: 25))
                
                .padding()
            
            Spacer()
            
            Text(arText)
                .font(.montserrat(.boldItalic, size: 30))
                .padding()
        }
        
        .background(Color.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 12)
        
    }
}

//MARK: Model

struct DictionaryItem: Decodable, Identifiable {
    var id: Int
    var rusText: String
    var arText: String
}


class DictionaryViewModel: ObservableObject {
    @Published var items: [DictionaryItem] = []
    
    init() {
        loadJsonData()
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
            }
        } catch {
            print(error)
        }
    }
}
