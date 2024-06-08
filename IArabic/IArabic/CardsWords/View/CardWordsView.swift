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
    
    @State private var stateEmptyView = false
    
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    @FetchRequest(entity: Words.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Words.title, ascending: false)]) 
    
    var words: FetchedResults<Words>
    
    var body: some View {
            VStack() {
                navigationView
                
                Spacer()
                
                if words.isEmpty {
                    BackgroundEmptyView(title: "Мир тебе, Арабсит",
                                        description: "Нажми на \("+") и добавь новое слово",
                                        isOn: $presentNewWord)
                } else {
                    CardNewWord2(stateImageAssociate: $isToggleOn, words: words)
                }
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
    @Binding var stateImageAssociate: Bool
    var words: FetchedResults<Words>
    
    let speechService = SpeechService()
    
    var body: some View {
        LazyVStack {
                ZStack {
                    ForEach(words.indices, id: \.self) { index in
                        ZStack(alignment: .top) {
                            
                            LazyVStack {
                                Rectangle()
                                    .fill(Color.custom.backgroundColor)
                                    .frame(width: 300, height: 25)
                                
                                LazyVStack(spacing: 6) {
                                    Text(words[index].translate ?? "" )
                                        .font(.montserrat(.light, size: 25))
                                    
                                    Text(words[index].title ??  "Арабское")
                                        .font(.montserrat(.regular, size: 18))
                                    
                                    if let data = words[index].imageMain {
                                        AsyncImage(data: data)
                                            .frame(width: 230, height: 300)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                
                                .frame(width: 300, height: 450)
                                .background(Color.custom.white)
                                .cornerRadius(20)
                                
                                Spacer()
                            }
                            .cornerRadius(20)
                            
                            audioView(text: words[index].translate ?? "")
                                .offset(y: 10)
                            
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .opacity(currentIndex == index ? 1.0 : 0.7)
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
    
    
    private func audioView(text: String) -> some View {
        Button {
            speechService.say(text)
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

struct BackgroundEmptyView: View {
    var title: String
    var description: String
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 55) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.montserrat(.bold, size: 24))
                    
                    Text(description)
                        .foregroundColor(Color.white)
                        .font(.montserrat(.regular, size: 20))
                    }
                
                Button {
                    isOn = true
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.custom.lightYellow)
                        
                        Circle()
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color.custom.white)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 18))
                            .foregroundColor(Color.custom.yellow)
                    }
                }
                
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 22)
        }
        .frame(width: 316, height: 370)
        .background(Color.custom.yellow)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.6), radius: 50, x: 1, y: 1)
    }
}


import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil

    func loadImage(from data: Data?) {
        guard let data = data else { return }
        DispatchQueue.global().async {
            let loadedImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.image = loadedImage
            }
        }
    }
}

struct AsyncImage: View {
    @StateObject private var loader = ImageLoader()
    let data: Data

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            loader.loadImage(from: data)
        }
    }
}
