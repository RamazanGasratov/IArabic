//
//  NewWordView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 07.02.2024.
//

import SwiftUI

struct NewWordView: View {
    @State private var russianWord: String = ""
    
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
            .applyBG()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Новое слово")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {} label: {
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
        Button {} label: {
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
        Button {} label: {
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
            Text("Слово")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.bold, size: 18))
            
          Text("на русском языке")
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.semibold, size: 13))
            
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
            
            TextField(text: $russianWord, label: {
                Text("Текст")
                    .font(.montserrat(.regular, size: 17))
            })
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

