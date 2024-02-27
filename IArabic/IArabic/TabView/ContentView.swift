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
    @StateObject private var coreDataViewModel = CoreDataViewModel()
    @State var selectedTab: Tab = .wordCards
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                
                switch tab {
                case .library:
                    coordinator.build(page: .library)
                        .sheet(item: $coordinator.sheet) { sheet in
                            coordinator.build(sheet: sheet)
                        }
                        .tabItem {
                            tab.image
                           Text(tab.text)
                        }
                        .tag(tab.index)
                case .wordCards:
                    coordinator.build(page: .wordCards)
                        .sheet(item: $coordinator.sheet) { sheet in
                            coordinator.build(sheet: sheet)
                        }
                        .tabItem {
                            tab.image
                            Text(tab.text)
                        }
                        .tag(tab.index)
                case .dictionary:
                    coordinator.build(page: .dictionary)
                        .tabItem {
                            tab.image
                            Text(tab.text)
                        }
                        .tag(tab.index)
                }
            }
        }
        .tint(Color.custom.yellow)
        .environmentObject(coordinator)
        .environmentObject(coreDataViewModel)
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
