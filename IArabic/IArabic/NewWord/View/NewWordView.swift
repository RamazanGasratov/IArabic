//
//  NewWordView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 07.02.2024.
//

import SwiftUI
import AVFoundation

struct NewWordView: View {

    @State private var showMainSheet = false
    @State private var showAssSheet = false
    @State private var imageMain = UIImage()
    @State private var associateImage = UIImage()
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm = NewWordViewModel()
    
    @EnvironmentObject private var coordinator: Coordinator
    
    @Environment(\.managedObjectContext) var moc
    
    let speechService = SpeechService()

    var editingWord: Words?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    VStack(spacing: 25) {
                        HStack(spacing: 5) {
                            CustomAddView(image: $imageMain, showSheet: $showMainSheet, title: "Картинка", description: "Вставьте картинку \n для слова")
                            
//                            Spacer()
//                            
//                            CustomAddView(image: $associateImage, showSheet: $showAssSheet, title: "Ассоциация", description: "Картинка похожая на \n звучание слова")
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 25)
                        
                        translateView
                        
                        Spacer()
                    }
                    
                    if vm.showAlert == true {
                        CustomAlertError(title: vm.titleError, description: vm.messengError, isOn: $vm.showAlert)
                    }
                }
            }
            .sheet(isPresented: $showMainSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$imageMain)
            }
            
            .sheet(isPresented: $showAssSheet) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$associateImage)
            }
            .applyBG()
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Новое слово")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
        
    }
    
    private var cancelButton: some View {
        Button {
           dismiss()
        } label: {
            Text("Отменить")
                .foregroundColor(Color.custom.yellow)
                .font(.montserrat(.regular, size: 17))
        }
    }
   
    private var saveButton: some View {
        Button {
            guard !vm.arabWord.isEmpty,
                  !vm.rusWord.isEmpty,
                  let imageMainData = imageMain.pngData(),
//                  let imageAssociateData = associateImage.pngData(),
                  !imageMainData.isEmpty
                /*  !imageAssociateData.isEmpty*/ else {
                
                vm.showAlert = true
                vm.titleError = "Не жульничай 🤓"
                vm.messengError = "Сначала заполни все поля (вставь картинки и слово с переводом)"
                return
            }
            
            saveWord()
            dismiss()
        } label: {
            Text("Сохранить")
                .foregroundColor(Color.custom.yellow)
                .font(.montserrat(.regular, size: 17))
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
                CustomWordAndDetailView(text: "Слово", description: "на русском языке")
                
                Spacer()
            
                Button {
                    vm.translate(prefix: "ar")
                } label: {
                    Text("Перевести")
                        .foregroundColor(Color.custom.yellow)
                        .padding(12)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.custom.yellow, lineWidth: 2))
                }
            }
            
            TextField(text: $vm.rusWord, label: {
                Text("Текст")
                    .foregroundColor(Color.custom.lightGray)
                    .font(.montserrat(.regular, size: 17))
            })
            .padding(.top, 20)
            
            Divider()
                .frame(minHeight: 1)
                .background(Color.custom.lightGray)
        }
    }
    
    private var translateArabicView: some View {
        VStack(alignment: .leading) {
            CustomWordAndDetailView(text: "Перевод", description: "на арабском языке")
           
            TextField(text: $vm.arabWord, label: {
                Text("Текст")
                    .foregroundColor(Color.custom.lightGray)
                    .font(.montserrat(.regular, size: 17))
            })
            .padding(.top, 20)
            
            Divider()
                .frame(minHeight: 1)
                .background(Color.custom.lightGray)
        }
    }
    
    private var audioView: some View {
        HStack {
            Text("Звук")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.bold, size: 18))
            
            Spacer()
            
            Button {
                speechService.say(vm.arabWord)
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.custom.yellow)
                    .padding(12)
                    .background(Circle().fill(Color.custom.white))
                    .overlay(Circle().stroke(Color.custom.yellow, lineWidth: 2))
            }
        }
    }
    
    private func saveWord() {
        
        guard let imageMainData = imageMain.jpegData(compressionQuality: 1.0) /*let imageAssociateData = associateImage.jpegData(compressionQuality: 1.0)*/ else { return }

        let newWord = Words(context: self.moc)
        newWord.imageMain = imageMainData
//        newWord.associatImage = imageAssociateData
    
        newWord.title = vm.rusWord
        newWord.translate = vm.arabWord

         do {
           try self.moc.save()
         } catch {
           print(error.localizedDescription)
         }
    }
 
}

#Preview {
    NewWordView()
}

struct CustomAlertError: View {
    var title: String
    var description: String
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.montserrat(.bold, size: 22))
                    
                    Text(description)
                        .foregroundColor(Color.white)
                        .font(.montserrat(.regular, size: 15))
                    }
                
                Button {
                    isOn = false
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.custom.lightYellow)
                        
                        Circle()
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color.custom.white)
                        
                        Text("Ок")
                            .font(.montserrat(.regular, size: 16))
                            .foregroundColor(Color.custom.yellow)
                    }
                }
                
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 22)
        }
        .frame(width: 316, height: 188)
        .background(Color.custom.yellow)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.6), radius: 50, x: 1, y: 1)
    }
}

class SpeechService {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var rate = AVSpeechUtteranceDefaultSpeechRate
    
    func say(_ phrase: String) {
        
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = rate
        utterance.voice = AVSpeechSynthesisVoice(language: "ar-SA")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.ar-001.Maged")
        
        synthesizer.speak(utterance)
    }

}
