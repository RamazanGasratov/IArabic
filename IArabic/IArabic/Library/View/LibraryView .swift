//
//  LibraryView .swift
//  IArabic
//
//  Created by Ramazan Gasratov on 11.02.2024.
//

import SwiftUI

struct LibraryView: View {
    @State private var presentNewWord: Bool = false
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @State  var selectedWord: Words?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Библиотека")
                        .font(.montserrat(.extraBold, size: 30))
                        .padding(.leading, 10)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                .padding(.top, 40)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        Button(action: {
                            self.presentNewWord = true
                        }) {
                            VStack(spacing: 10) {
                                Image(systemName: "plus") //
                                    .foregroundColor(Color.custom.yellow)
                                    .padding(20)
                                    .background(
                                        Circle().fill(Color.custom.lightYellow)
                                    )
                                
                                VStack(spacing: 1) {
                                    Text("Новое")
                                        .font(.montserrat(.bold, size: 14))
                                    
                                    Text("слово")
                                        .font(.montserrat(.bold, size: 13))
                                }
                                .foregroundColor(Color.custom.black)
                                .padding(.horizontal, 5)
                            }
                            .frame(width: 115, height: 170)
                            .background(Color.white)
                            .cornerRadius(15)
                        }
                        
                        ForEach(vmCoreData.saveEntities, id: \.id) { word in
                            VStack(spacing: 10) {
                                ImageManager.loadImage(from: word.imageMain)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 85, height: 85)
                                    .clipShape(Circle())
                                
                                VStack(spacing: 5) {
                                    Text(word.translate ?? "")
                                        .font(.montserrat(.bold, size: 16))
                                        .lineLimit(1)
                                    Text(word.title ?? "" )
                                        .font(.montserrat(.regular, size: 12))
                                        .lineLimit(1)
                                }
                                .foregroundColor(Color.custom.black)
                                .padding(.horizontal, 5)
                            }
                            .frame(width: 115, height: 170)
                            .background(Color.white)
                            .cornerRadius(15)
//                            .onTapGesture {
//                                presentNewWord = true
//                                selectedWord = word
//                            }
                           
                        }
                        
                    }
                    .fullScreenCover(isPresented: $presentNewWord, content: {
                        NewWordView(editing: selectedWord).environmentObject(vmCoreData) // Используйте selectedWord для передачи выбранного слова
                       })
                    .padding()
                }
            }
            .applyBG()
//            .sheet(isPresented: $presentNewWord) {
//                // Передаём CoreDataViewModel в новое представление
//                NewWordView().environmentObject(vmCoreData)
//            }
        }
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

