//
//  IArabicApp.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI

@main
struct IArabicApp: App {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white // Установка белого фона для UITabBar
        UITabBar.appearance().isTranslucent = false // Отключение прозрачности
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // Установить белый фон
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
