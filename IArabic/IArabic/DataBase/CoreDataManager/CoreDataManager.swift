//
//  CoreDataManager.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 09.02.2024.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var saveEntities: [Words] = []
    
    init() {
        container = NSPersistentContainer(name: "IArabic")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        featchCardWords()
    }
    
    func featchCardWords() {
            let request = NSFetchRequest<Words>(entityName: "Words")
            
            do {
                self.saveEntities = try self.container.viewContext.fetch(request)
            } catch let error {
                print("Error featching. \(error)")
            }
    }
    
    func addNewWord(title: String, translateText: String, imageMain: Data, associatImage: Data) {
        let newWord = Words(context: container.viewContext)
        newWord.title = title
        newWord.translate = translateText
        newWord.imageMain = imageMain
        newWord.associatImage = associatImage
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            featchCardWords()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}
