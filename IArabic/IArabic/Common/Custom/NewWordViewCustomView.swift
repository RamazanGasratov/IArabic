//
//  CustomAddView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 10.02.2024.
//

import SwiftUI

struct CustomAddView: View {
    @Binding var image: UIImage
    @Binding var showSheet: Bool
    @State private var showingAlert = false
    var title: String
    var description: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            if let imgData = image.pngData(), imgData.count > 0 {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 168, height: 192)
                    .scaledToFill()
                    .cornerRadius(20)
           
                    .overlay(
                        Button(action: {
                            self.showingAlert = true
                        }) {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(Color.custom.yellow)
                                .imageScale(.large)
                                .padding()
                        }, alignment: .bottomTrailing
                    )
            } else {
                Button(action: { showSheet = true }) {
                    VStack(spacing: 19) {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .foregroundColor(Color.custom.yellow)
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(colorScheme == .dark ? Color.custom.backgroundColor : Color.custom.lightYellow)
                            )
                        Text(title)
                            .foregroundColor(Color.custom.black)
                            .font(.montserrat(.bold, size: 16))
                        
                        Text(description)
                            .foregroundColor(Color.custom.lightGray)
                            .font(.montserrat(.semibold, size: 14))
                    }
                    .frame(width: 164, height: 160)
                    .padding(.vertical, 20)
                    .background(Color.custom.white)
                    .cornerRadius(20)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Удалить изображение?"),
                        primaryButton: .destructive(Text("Удалить")) {
                            self.image = UIImage() // Удаляем изображение
                        },
                        secondaryButton: .cancel(Text("Отмена"))
                    )
                }
    }
}


struct CustomWordAndDetailView: View {
    var text: String
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .foregroundColor(Color.custom.black)
                .font(.montserrat(.bold, size: 18))
            
            Text(description)
                .foregroundColor(Color.custom.lightGray)
                .font(.montserrat(.semibold, size: 13))
        }
    }
}
