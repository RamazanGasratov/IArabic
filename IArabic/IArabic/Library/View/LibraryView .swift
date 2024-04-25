//
//  LibraryView .swift
//  IArabic
//
//  Created by Ramazan Gasratov on 11.02.2024.
//

import SwiftUI
import UIKit
import CoreData

struct LibraryView: View {
    @State private var presentNewWord: Bool = false
    @State private var showingDeleteAlert = false
    @State private var wordToDelete: Words?
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Words.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Words.title, ascending: false)]) var words: FetchedResults<Words>
    
    var body: some View {
        VStack {
            navigationBar
                .padding(.horizontal, 12)
                .padding(.top, 10)
            
            libraryCellRow
            Spacer()
        }
        .applyBG()
        .fullScreenCover(isPresented: $presentNewWord, content: {
            NewWordView()
        })
        .alert("Удалить слово?", isPresented: $showingDeleteAlert) {
            Button("Удалить", role: .destructive) {
                if let word = wordToDelete {
                    withAnimation {
                        delete(word)
                    }
                }
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Вы уверены, что хотите удалить это слово?")
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Text("Библиотека")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.extraBold, size: 30))
            Spacer()
        }
    }
    
    private var libraryCellRow: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                Button(action: {
                    self.presentNewWord = true
                }) {
                    newWordButton
                }
                
                ForEach(words) { word in
                   LibraryItemView(word: word)
                        .onTapGesture(count: 2) {
                            withAnimation {
                                   let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                   impactMed.impactOccurred()
   
                                   wordToDelete = word
                                   showingDeleteAlert = true
                            }
                        }
                        .cornerRadius(15)
                }
            }
            .padding()
        }
    }
    
    private var newWordButton: some View {
        VStack(spacing: 45) {
            Image(systemName: "plus") //
                .font(.system(size: 40))
                .foregroundColor(Color.custom.yellow)
                .padding(30)
                .background(
                    Circle().fill(Color.custom.lightYellow)
                )
            
            VStack(spacing: 1) {
                Text("Новое")
                    .font(.montserrat(.bold, size: 22))
                
                Text("слово")
                    .font(.montserrat(.bold, size: 20))
            }
            .foregroundColor(Color.custom.black)
            .padding(.horizontal, 5)
        }
        .frame(minWidth: 170, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
        .background(Color.custom.white)
        .cornerRadius(15)
    }
}

#Preview {
    LibraryView()
}

class ImageManager {
    static func loadImage(from data: Data?) -> Image {
        guard let imageData = data, let uiImage = UIImage(data: imageData) else {
            return Image(systemName: "photo") // Заменитель, если изображение не доступно
        }
        return Image(uiImage: uiImage)
    }
}

extension LibraryView {
    
    func delete(_ word: Words) {
            // Получите контекст управляемого объекта
            let managedObjectContext = word.managedObjectContext
            
            // Удалите слово из контекста
            managedObjectContext?.delete(word)
            
            // Сохраните изменения в контексте
            do {
                try managedObjectContext?.save()
            } catch {
                // Обработка возможной ошибки
                print("Ошибка при сохранении контекста: \(error)")
            }
    }
}
