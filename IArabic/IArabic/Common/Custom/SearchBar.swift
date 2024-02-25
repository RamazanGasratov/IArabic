//
//  SearchBar.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 25.02.2024.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        Group {
            HStack {
                TextField("Поиск...", text: $text)
                    .font(.montserrat(.regular, size: 17))
                    .accentColor(Color.custom.yellow)
                    .padding(9)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                
                    .overlay(HStack {
                        
                        Spacer()
                        
                        if isEditing == true {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    })
                    .padding(.horizontal, 10)
                
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing == true {
                    Button(action: {
                        self.isEditing = false
                        self.text = ""
                        
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text("Отмена")
                            .font(.montserrat(.medium, size: 16))
                            .foregroundColor(Color.custom.yellow)
                    }.padding(.trailing, 10)
                        .transition(.move(edge: .trailing))
                        .animation(.default, value: 1)
                }
            }
        }
    }
}
