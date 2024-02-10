//
//  NewWordViewModel.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 10.02.2024.
//

import SwiftUI

final class NewWordViewModel: ObservableObject {
    @Published var arabWord: String = ""
    
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
