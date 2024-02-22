//
//  ContentView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    @State var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LibraryView().environmentObject(CoreDataViewModel())
                .tabItem {
                    Image(systemName: "building.columns")
                }
                .tag(0)
            
                coordinator.build(page: .cardWords)
                  
                    .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                        coordinator.build(fullScreenCover: fullScreenCover)
                    }
                    .tabItem {
                        Image(systemName: "menucard")
                    }
                    .tag(1)
            
                
            DictionaryView()
                .tabItem {
                    Image(systemName: "character.book.closed")
                }
                .tag(2)
        }
        .environmentObject(coordinator)
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
