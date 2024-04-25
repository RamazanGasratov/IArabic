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
    @Published var error: String = ""
    
    func translate(prefix: String) {
    
        Network.shared.translate(text: rusWord, prefix: prefix) {[weak self] result, error in
            guard let self, let result else {
           
                return print(error)
            }
            DispatchQueue.main.async {
                self.arabWord = result
            }
        }
    }
}
