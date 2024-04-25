//
//  CardWordsView.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 04.02.2024.
//

import SwiftUI
import CoreData

struct CardWordsView: View {
    @State private var isToggleOn = false
    @State private var isDestinationNewWord = false
    @State private var presentNewWord: Bool = false
    
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    @FetchRequest(entity: Words.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Words.title, ascending: false)]) var words: FetchedResults<Words>
    
    var body: some View {
            VStack() {
                navigationView
                
                showAssociation
                    .padding(.horizontal, 12)
                    .padding(.top, 5)
                
                Spacer()
                
                CardWordsRow(words: words)
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

#Preview {
    CardWordsView()
}
