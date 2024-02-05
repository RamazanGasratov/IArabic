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
    
    @State private var selectedTab: Int = 0
    
    @State var currentTab: Tab = .wordCards

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack {
                switch Tab.allCases[selectedTab] {
                case.library:
                    CardWordsView()
                case.wordCards:
                    CardWordsView()
                case.dictionary:
                    CardWordsView()
                }
            }
            
            Spacer()
            
            CustomTabs(currentTab: $currentTab, tabs: Tab.allCases)
                .background(Color.custom.white)
                .border(Color.custom.lightGray, width: 0.3)
        }
        .background(Color.custom.backgroundColor).ignoresSafeArea()
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
                Color.custom.white
                    .ignoresSafeArea()
            }
    }
}
