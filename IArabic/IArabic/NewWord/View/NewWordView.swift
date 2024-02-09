//
//  NewWordView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 07.02.2024.
//

import SwiftUI

final class NewWordViewModel: ObservableObject {
    @Published var arabWord: String = ""
    
    @StateObject var vmCoreData = CoreDataViewModel()
    
    func translate(text: String, prefix: String) {
        
        Network.shared.translate(text: text, prefix: prefix) {[weak self] translate, error in
            guard let self = self, let translate = translate else {
                print(error)
                return
            }
            DispatchQueue.main.async {
                self.arabWord = translate
            }
            
        }
        
    }
    
}


struct NewWordView: View {
    @State private var russianWord: String = ""
    @State private var showMainSheet = false
    @State private var showAssSheet = false
    @State private var imageMain = UIImage()
    @State private var associateImage = UIImage()
    
    @ObservedObject var vm = NewWordViewModel()
    @StateObject var vmCoreData = CoreDataViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
      
            VStack(spacing: 25) {
                HStack(spacing: 5) {
                    mainView
                    
                    Spacer()
                    
                    associationView
                }
                .padding(.horizontal, 15)
                .padding(.top, 25)
                
                
                translateView
                
                Spacer()
            }
            .sheet(isPresented: $showMainSheet) {
                           // Pick an image from the photo library:
                       ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageMain)

                           //  If you wish to take a photo from camera instead:
                           // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                   }
        
            .sheet(isPresented: $showAssSheet) {
                           // Pick an image from the photo library:
                       ImagePicker(sourceType: .photoLibrary, selectedImage: self.$associateImage)

                           //  If you wish to take a photo from camera instead:
                           // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                   }
            .applyBG()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Новое слово")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        guard  let imageMain = imageMain.pngData() ,
                               let imageAss = associateImage.pngData()
                        else {return}
                        
                        vmCoreData.addNewWord(title: russianWord, translateText: vm.arabWord, imageMain: imageMain, associatImage: imageAss)
                        dismiss()
                    } label: {
                       Text("Сохранить")
                            .font(.montserrat(.regular, size: 17))
                            .foregroundColor(Color.custom.yellow)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {} label: {
                       Text("Отменить")
                            .font(.montserrat(.regular, size: 17))
                            .foregroundColor(Color.custom.yellow)
                    }
                }
            }
        
    }

    private var mainView: some View {
        Button {
            showMainSheet = true
        } label: {
            VStack(spacing: 19) {
                Image(systemName: "plus")
                    .font(.system(size: 25))
                    .foregroundColor(Color.custom.yellow)
                    .padding(20)
                    .background(
                        Circle()
                            .fill(Color.custom.lightYellow)
                    )
                
                VStack(spacing: 13) {
                    Text("Основная")
                        .foregroundColor(Color.custom.black)
                        .font(.montserrat(.bold, size: 16))
                    
                    Text("Основная картинка \n слова")
                        .foregroundColor(Color.custom.lightGray)
                        .font(.montserrat(.semibold, size: 14))
                }
            }
            .frame(width: 167, height: 192)
            .background(Color.custom.white)
            .clipShape(
            RoundedRectangle(cornerRadius: 20)
            )
        }
    }
    
    private var associationView: some View {
        Button {
            showAssSheet = true
        } label: {
            VStack(spacing: 19) {
                Image(systemName: "plus")
                    .font(.system(size: 25))
                    .foregroundColor(Color.custom.yellow)
                    .padding(20)
                    .background(
                        Circle()
                            .fill(Color.custom.lightYellow)
                    )
                
                VStack(spacing: 13) {
                    Text("Ассоциация")
                        .foregroundColor(Color.custom.black)
                        .font(.montserrat(.bold, size: 16))
                    
                    Text("Картинка похожая на \n звучание слова")
                        .foregroundColor(Color.custom.lightGray)
                        .font(.montserrat(.semibold, size: 14))
                }
            }
            .frame(width: 167, height: 192)
            .background(Color.custom.white)
            .clipShape(
            RoundedRectangle(cornerRadius: 20)
            )
        }
    }
    
    private var translateView: some View {
        ZStack {
            VStack(spacing: 25) {
                russianLanguageView
                translateArabicView
                audioView
            }
            .padding([.top, .bottom], 50)
            .padding(.horizontal, 15)
            .background(
                Color.custom.white
            )
            .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        }
        .padding(.horizontal, 15)
    }
    
    private var russianLanguageView: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Слово")
                        .foregroundColor(Color.custom.black)
                        .font(.montserrat(.bold, size: 18))
                    
                    Text("на русском языке")
                        .foregroundColor(Color.custom.black)
                        .font(.montserrat(.semibold, size: 13))
                }
                
                Spacer()
                
                Button {
                    vm.translate(text: russianWord, prefix: "ar")
                } label: {
                    Text("Перевести")
                        .foregroundColor(Color.custom.yellow)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.custom.yellow, lineWidth: 2))
                }
            }
            
            TextField(text: $russianWord, label: {
                Text("Текст")
                    .font(.montserrat(.regular, size: 17))
            })
            .padding(.top, 20)
            Divider()
        }
    }
    
    private var translateArabicView: some View {
        VStack(alignment: .leading) {
            Text("Перевод")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.bold, size: 18))
            
            Text("на арабском языке")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.semibold, size: 13))
            
//            TextField(text: $russianWord, label: {
                Text("Текст: \(vm.arabWord)")
                    .font(.montserrat(.regular, size: 17))
//            })
            .padding(.top, 20)
            Divider()
        }
    }
    
    private var audioView: some View {
        HStack {
            Text("Звук")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.bold, size: 18))
            
            Spacer()
            
            Button {} label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.custom.yellow)
                    .padding(12)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.custom.yellow, lineWidth: 2))
            }
        }
    }

}

#Preview {
    NewWordView()
}



struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
