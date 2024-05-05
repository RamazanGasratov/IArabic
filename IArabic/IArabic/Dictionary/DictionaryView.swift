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
    @State private var showAlert: Bool = false
    
//    @State private var selectedCategory: Category? = .init(id: "one")
    
    let categories = [
        Category(id: "OneMed", name: "первый том"),
        Category(id: "TwoMed", name: "второй том"),
        Category(id: "ThreeMed", name: "третий том")
    ]
    
    var body: some View {
        NavigationStack {
            navigationView
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredItems) { item in // Используйте отфильтрованные элементы
                        DictionaryViewItem(rusText: item.rusText, arText: item.arText)
                    }
                }
            }
            .applyBG()
            .padding(.bottom, 5)
            .overlay(
                Group {
                    if showAlert == true {
                        CustomAlertError(title: "!!!", description: "Словарь составлен из слов мединского курса", isOn: $showAlert)
                    }
               
                }
            )
            .navigationTitle("Словарь")
            
        }
    }
    
    private var navigationView: some View {
        VStack {
//            HStack {
////                Text("Словарь")
////                    .font(.montserrat(.bold, size: 30))
//                
////                Spacer()
////                
////                Button {
////                    showAlert.toggle()
////                } label: {
////                    Image(systemName: "exclamationmark.circle")
////                        .font(.system(size: 20))
////                        .foregroundColor(Color.custom.yellow)
////                }
//            }
//            .padding(.horizontal)
//            .padding(.top, 2)
            
            SearchBar(text: $viewModel.searchText, isEditing: $isSearch) // Убедитесь, что SearchBar обновляет $text
            
            categoryDictionaryView
        }
        .padding(.bottom, 10)
        .background(Color.custom.white)
    }
    
    private var categoryDictionaryView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(categories) { category in
                    CategoryButton(category: category, selection: $viewModel.selectedCategory)
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .overlayPreferenceValue(CategoryPreferenceKey.self) { preferences in
            GeometryReader { proxy in
                if let selected = preferences.first(where: { $0.category == viewModel.selectedCategory }) {
                    let frame = proxy[selected.anchor]

                    Rectangle()
                        .fill(.black)
                        .frame(width: frame.width, height: 2)
                        .position(x: frame.midX, y: frame.maxY)
                }
            }
        }
    }
}



#Preview {
    DictionaryView()
}

struct CategoryButton: View {
    var category: Category
    @Binding var selection: Category?
    
    var body: some View {
        
        Button {
            withAnimation {
                selection = category
            }
        } label: {
            Text(category.name)
                .font(.montserrat(.medium, size: 16))
        }
        .buttonStyle(.plain)
        .accessibilityElement()
        .accessibilityLabel(category.id)
        .anchorPreference(key: CategoryPreferenceKey.self, value: .bounds, transform: { [CategoryPreference(category: category, anchor: $0)] })
    }
}


struct Category: Identifiable, Equatable {
    let id: String
    let name: String
}

struct CategoryPreference: Equatable {
    let category: Category
    let anchor: Anchor<CGRect>
}

struct CategoryPreferenceKey: PreferenceKey {
    static let defaultValue = [CategoryPreference]()
    
    static func reduce(value: inout [CategoryPreference], nextValue: () -> [CategoryPreference]) {
        value.append(contentsOf: nextValue())
    }
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
                .padding(8)
                .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.custom.lightYellow)
                )
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


