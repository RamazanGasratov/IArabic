//
//  DictionaryView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 12.02.2024.
//

import SwiftUI

struct DictionaryView: View {
    @StateObject private var viewModel = DictionaryViewModel()
    @State private var text: String = ""
    @State private var isSearch = false
    
    var body: some View {
        VStack {
            navigationView
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredItems) { item in // Используйте отфильтрованные элементы
                        DictionaryViewItem(rusText: item.rusText, arText: item.arText)
                    }
                }
            }
            .padding(.bottom, 5)
        }
        .applyBG()
    }
    
    private var navigationView: some View {
        VStack {
            HStack {
                Text("Топ слов")
                    .font(.montserrat(.bold, size: 30))
                
                Spacer()
            }
            .padding(.leading)
            .padding(.top, 2)
            
            SearchBar(text: $viewModel.searchText, isEditing: $isSearch) // Убедитесь, что SearchBar обновляет $text
        }
        .padding(.bottom, 10)
        .background(Color.custom.white)
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
                .foregroundStyle(Color.custom.black)
                .font(.montserrat(.medium, size: 25))
                
                .padding()
            
            Spacer()
            
            Text(arText)
                .foregroundStyle(Color.custom.black)
                .font(.montserrat(.boldItalic, size: 30))
                .padding()
        }
        .background(Color.custom.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 12)
        .padding(.top, 20)
    }
}

//MARK: Model

struct DictionaryItem: Decodable, Identifiable {
    var id: Int
    var rusText: String
    var arText: String
}


