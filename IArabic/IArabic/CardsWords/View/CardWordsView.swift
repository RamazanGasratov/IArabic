//
//  CardWordsView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 04.02.2024.
//

import SwiftUI
import CoreData
import Shimmer

struct CardWordsView: View {
    @AppStorage("isToggleOn") private var isToggleOn: Bool = false
    @State private var isDestinationNewWord = false
    @State private var presentNewWord: Bool = false
    
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    @FetchRequest(entity: Words.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Words.title, ascending: false)]) 
    var words: FetchedResults<Words>
    
    var body: some View {
            VStack() {
                navigationView
                
                showAssociation
                    .padding(.horizontal, 12)
                    .padding(.top, 5)
                
                Spacer()
                
//                CardWordsRow(stateAssociate: $isToggleOn, words: words)
                
                CardNewWord2(stateImageAssociate: $isToggleOn, words: words)
                Spacer()
            }
            .background(Color.custom.backgroundColor)
            .fullScreenCover(isPresented: $presentNewWord, content: {
                NewWordView()
            })
    }
    
    private var navigationView: some View {
        HStack {
            Text("Карточки")
                .font(.montserrat(.bold, size: 28))
            
            Spacer()
            
            Button {
                presentNewWord = true
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(Color.custom.yellow)
            }
            .font(.system(size: 25))
        }
        .padding()
        .background(Color.custom.white)
    }
    
    private var showAssociation: some View {
        HStack {
            Text("Показать ассоциацию")
                .foregroundColor(Color.custom.black)
                .padding()
            Spacer()
            
            Toggle("", isOn: $isToggleOn)
                .labelsHidden()
                .padding()
        }
        .frame(height: 54)
        .background(Color.white)
        .cornerRadius(20)
    }
}

//#Preview {
//    CardNewWord2(words: <#FetchedResults<Words>#>)
//}

struct CardNewWord2: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    private let images: [String] = ["сын", "дочь", "сын", "сын", "дочь"]
    
    @Binding var stateImageAssociate: Bool
    
//    @State var currentIndex: Int = 0
//    @Binding var stateAssociate: Bool
//    
    var words: FetchedResults<Words>
    
    var body: some View {
            VStack {
                ZStack {
                    ForEach(words.indices, id: \.self) { index in
                        ZStack(alignment: .top) {
                            
                            VStack {
                                Rectangle()
                                    .fill(Color.custom.backgroundColor)
                                    .frame(width: 300, height: 25)
                                
                                VStack(spacing: 6) {
                                    Text(words[index].title ??  "Арабское")
                                        .font(.montserrat(.semibold, size: 22))
                                    Text(words[index].translate ?? "" )
                                        .font(.montserrat(.light, size: 20))
                                    
                                    
                                 // images
                                    if let image: UIImage = words[index].imageMain.flatMap({ UIImage(data: $0) }) {
                                        Image(uiImage: image) // -  основная фотка
                                            .resizable()
                                            .frame(width: 300, height: stateImageAssociate ? 208 : 380)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
//                                    imagesCardWords(imageMain: words[index].imageMain, imageAssociate: words[index].associatImage, stateImageAssociate: $stateImageAssociate)
                                }
                                .frame(width: 300, height: 400)
                                .background(Color.red)
                                .cornerRadius(20)
                                
                            }
                            .cornerRadius(20)
                            
                            audioView
                               
                        }
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                            .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                            .offset(x: CGFloat(index - currentIndex) * 300 + dragOffset, y: 0)
                    }
                }
                .gesture(
                DragGesture()
                    .onEnded({ value in
                        let threshod: CGFloat = 50
                        if value.translation.width > threshod {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.width < -threshod {
                            withAnimation {
                                currentIndex = min(words.count - 1, currentIndex + 1)
                            }
                        }
                    })
                )
            }
    }
    
    
    private var audioView: some View {
        Button {
            
        } label: {
            Image(systemName: "play.fill")
                .foregroundColor(Color.custom.lightGreen)
                .frame(width: 45, height: 45)
                .background(
                    Circle().fill(Color.white)
                        .shadow(radius: 6, y: 5)
                )
        }
    }
    
    private func loadImageAsynchronously(imageData: Data?, completion: @escaping (UIImage?) -> Void) {
        let image: UIImage? = imageData.flatMap { UIImage(data: $0) }
        DispatchQueue.main.async {
            completion(image)
        }
    }
}

struct imagesCardWords: View {
    
    @Binding var imageMain: Data?
    @Binding var imageAssociate: Data?
    
    @Binding var stateImageAssociate: Bool
    
    @State private var uiImageMain: UIImage? = nil
    @State private var uiImageAssociate: UIImage? = nil
    
    var body: some View {
        
        VStack {
            if let uiImageMain = uiImageMain {
                Image(uiImage: uiImageMain) // -  основная фотка
                    .resizable()
                    .frame(width: 300, height: stateImageAssociate ? 208 : 380)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }  else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 300, height: 208)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shimmering()
            }
            
            withAnimation {
                
                Group {
                    
                    if stateImageAssociate {
                        if let uiImageAssociate = uiImageAssociate {
                            Image(uiImage: uiImageAssociate) // -  ассоциация
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 280, height: 183)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 280, height: 183)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shimmering()
                        }
                    }
                }
            }
        }
    }
}

