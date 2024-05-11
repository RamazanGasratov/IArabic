//
//  NewWordViewModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 10.02.2024.
//

import SwiftUI
import Combine

final class NewWordViewModel: ObservableObject {
    @Published var arabWord: String = ""
    @Published var rusWord: String = ""
    @Published var showAlert = false
    
    @Published var titleError: String = ""
    @Published var messengError: String = ""
    
    func translate(prefix: String) {
    
        Network.shared.translate(text: rusWord, prefix: prefix) {[weak self] result, error in
            guard let self, let result else {
                self?.showAlert = true
                self?.titleError = error.title ?? ""
                self?.messengError = error.messeng ?? ""
                return print(error)
            }
            DispatchQueue.main.async {
                self.arabWord = result
            }
        }
    }
}
