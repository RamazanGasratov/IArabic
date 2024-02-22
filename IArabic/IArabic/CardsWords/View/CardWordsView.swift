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
    
    @EnvironmentObject var vmCoreData: CoreDataViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        NavigationView {
            VStack(spacing: -12) {
                showAssociation
                
                CardWordsRow(vmCoreData: vmCoreData)
            }
            .onAppear {
                vmCoreData.featchCardWords()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Все слова"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        coordinator.present(fullScreenCover: .newWord)
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color.custom.yellow)
                    }
                    .font(.system(size: 20))
                }
            }
            .background(Color.custom.backgroundColor)
            .fullScreenCover(isPresented: $isDestinationNewWord, content: {
                NewWordView().environmentObject(vmCoreData)            })
        }
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
        .padding()
    }
}

#Preview {
    CardWordsView()
}
