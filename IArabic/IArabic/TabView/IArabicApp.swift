//
//  IArabicApp.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 13.01.2024.
//

import SwiftUI
import CoreData

class PersistenceController: ObservableObject {
  let container = NSPersistentContainer(name: "IArabic")

  static let shared = PersistenceController()

   init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
}

@main
struct IArabicApp: App {
    
    let persistenceController = PersistenceController()
    
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
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
