//
//  ContentView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
//    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @State var selectedTab: Tab = .wordCards
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                
                switch tab {
                case .library:
                    LibraryView()
                        .tabItem {
                            tab.image
                           Text(tab.text)
                        }
                        .tag(tab.index)
                case .wordCards:
                    CardWordsView()
                        .tabItem {
                            tab.image
                            Text(tab.text)
                        }
                        .tag(tab.index)
                case .dictionary:
                    DictionaryView()
                        .tabItem {
                            tab.image
                            Text(tab.text)
                        }
                        .tag(tab.index)
                }
            }
        }
        .tint(Color.custom.yellow)
    }
}

#Preview {
    ContentView()
}

extension View {
    func applyBG() -> some View{
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.custom.backgroundColor
                    .ignoresSafeArea()
            }
    }
}
