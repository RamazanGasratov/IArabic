//
//  NewWordView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 07.02.2024.
//

import SwiftUI

struct NewWordView: View {
    @State private var russianWord: String = ""
    @State private var showMainSheet = false
    @State private var showAssSheet = false
    @State private var imageMain = UIImage()
    @State private var associateImage = UIImage()
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertDescription = ""
    
    @StateObject var vm = NewWordViewModel()
    
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @EnvironmentObject private var coordinator: Coordinator

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
     
            ScrollView {
                ZStack {
                    VStack(spacing: 25) {
                        HStack(spacing: 5) {
                            CustomAddView(image: $imageMain, showSheet: $showMainSheet, title: "Основная", description: "Основная картинка \n слова")
                            
                            Spacer()
                            
                            CustomAddView(image: $associateImage, showSheet: $showAssSheet, title: "Ассоциация", description: "Картинка похожая на \n звучание слова")
                        }
                        .padding(.horizontal, 15)
                        .padding(.top, 25)
                    
                        translateView
                        
                        Spacer()
                    }
                    
                    if showAlert == true {
                        CustomAlertError(title: alertTitle, description: alertDescription, isOn: $showAlert)
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
    
    private var cancelButton: some View {
        Button {
            coordinator.dismissFullScreenCover()
        } label: {
            Text("Отменить")
                .foregroundColor(Color.custom.yellow)
                .font(.montserrat(.regular, size: 17))
        }
    }
    
    private var saveButton: some View {
        Button {
            saveWord()
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
            CustomWordAndDetailView(text: "Перевод", description: "на арабском языке")
        
            Text(vm.arabWord)
                    .font(.montserrat(.regular, size: 25))
            
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
            
            Button {
        
            } label: {
                Image(systemName: "play.fill")
                    .foregroundColor(Color.custom.yellow)
                    .padding(12)
                    .background(Circle().fill(Color.white))
                    .overlay(Circle().stroke(Color.custom.yellow, lineWidth: 2))
            }
        }
    }

    private func saveWord() {
        // Проверка, что все поля и изображения заполнены
        if russianWord.isEmpty || vm.arabWord.isEmpty || imageMain.pngData() == nil || associateImage.pngData() == nil {
            // Обновляем состояния для показа алерта с сообщением об ошибке
            alertTitle = "Ошибка"
            alertDescription = "Так нельзя ! Заполни все поля, пожалуйста."
            showAlert = true
            return
        }
        
        // Если все в порядке, продолжаем процесс сохранения
        guard let imageMainData = imageMain.pngData(), let imageAssociateData = associateImage.pngData() else { return }
        
        vmCoreData.addNewWord(title: russianWord, translateText: vm.arabWord, imageMain: imageMainData, associatImage: imageAssociateData)
        
        dismiss()
    }
}

#Preview {
    CustomAlertError(title: "Ошибка", description: "Ошиаолоааовлаол аовоатаотва", isOn: .constant(true))
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

