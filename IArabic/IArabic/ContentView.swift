//
//  ContentView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: Hiding Native One
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @State var currentTab: Tab = .library

    var body: some View {
        VStack {
            TabView(selection: $currentTab){
                //MARK: Need to Apply BG For Each Tab View
                Text("Библиотека")
                    .applyBG()
                    .tag(Tab.library)
                CardsWordsView()
                    .tag(Tab.wordCards)
                Text("Словарь")
                    .applyBG()
                    .tag(Tab.dictionary)
            }
            //MARK: Custom Tab Bar
            CustomTabBar(currentTab: $currentTab)
        }
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
                Color(.gray)
                    .ignoresSafeArea()
            }
    }
}
