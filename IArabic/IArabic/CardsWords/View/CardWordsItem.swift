//
//  CardWordsItem.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 04.02.2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Shimmer

struct CardWordsItem: View {
    var textTitle: String?
    var textTranslate: String?
    var imageMain: Data?
    var imageAssociate: Data?
    
    @Binding var stateImageAssociate: Bool
    
    @State private var uiImageMain: UIImage? = nil
    @State private var uiImageAssociate: UIImage? = nil
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 3) {
                Rectangle()
                    .fill(Color.custom.backgroundColor)
                    .frame(width: 100, height: 20)
                
                VStack {
                    textsCardWords
                        .padding(.top, 30)
                    
                    imagesCardWords
                        .padding()
                }
                .background(Color.custom.white)
                .cornerRadius(20)
                .padding(.horizontal, 20)
            }
            .cornerRadius(20)
            .background(Color.custom.backgroundColor)
            audioView
        }
        
        .background(Color.custom.backgroundColor)
        .onAppear {
            loadImageAsynchronously(imageData: imageMain) { image in
                    self.uiImageMain = image
            }
            loadImageAsynchronously(imageData: imageAssociate) { image in
                self.uiImageAssociate = image
            }
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
    
    private var imagesCardWords: some View {
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

    
    private var textsCardWords: some View {
        VStack(spacing: 6) {
            Text(textTranslate ?? "Арабское")
                .font(.montserrat(.semibold, size: 30))
            Text(textTitle ?? "Перевод")
                .font(.montserrat(.light, size: 18))
        }
    }
    
//    private var imagesCardWords: some View {
//        VStack {
//            if let uiImageMain = uiImageMain {
//                Image(uiImage: uiImageMain) // -  основная фотка
//                    .resizable()
//                    .frame(width: 300, height: stateImageAssociate ? 208 : 380)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//            }  else {
//               Image(systemName: "photo")
//                    .resizable()
//                    .frame(width: 300, height: 208)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .shimmering()
//            }
//            
//            withAnimation {
//                
//                Group {
//                    
//                    if stateImageAssociate {
//                        if let uiImageAssociate = uiImageAssociate {
//                            Image(uiImage: uiImageAssociate) // -  ассоциация
//                                .resizable()
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .frame(width: 280, height: 183)
//                        } else {
//                            Image(systemName: "photo")
//                                .resizable()
//                                .frame(width: 280, height: 183)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .shimmering()
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    private func loadImageAsynchronously(imageData: Data?, completion: @escaping (UIImage?) -> Void) {
        let image: UIImage? = imageData.flatMap { UIImage(data: $0) }
        DispatchQueue.main.async {
            completion(image)
        }
    }
}

//#Preview {
//    CardWordsItem()
//}


