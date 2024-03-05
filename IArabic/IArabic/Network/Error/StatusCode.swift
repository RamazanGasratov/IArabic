//
//  StatusCode.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 08.02.2024.
//

//    y0_AgAAAABcJ33zAATuwQAAAADfr_fGlFrCxQFgSy6nttw6LnJO_IATfs0


import Foundation

struct StatusCode: Error {
    var success: Bool
    var title: String?
    var messeng: String?
    
    init(success: Bool = true, title: String? = nil, messeng: String? = "неизвестная ошибка") {
        self.success = success
        self.title = title
        self.messeng = messeng
    }
    
    init(){
        self.success = true
        self.title = nil
        self.messeng = nil
    }
    
    init(error: Error?){
        self.success = error == nil //TODO: ????
        self.title = nil
        self.messeng = error?.localizedDescription
    }

    init(_ code: Int) {
        
        switch code {
        case 300:
            self.success = false
            self.title = "Ошибка"
            self.messeng = "Произошла ошибка в подготовке данных"
            
        case 200...399:
            self.success = true
            self.title = nil
            self.messeng = nil
            
        case 400:
            self.success = false
            self.title = "Ошибка авторизации"
            self.messeng = "Для получения этих данных вам требуется авторизация"
            
        default:
            self.success = false
            self.title = "неизвестная ошибка"
            self.messeng = "Что то пошло не так, повторите попытку позже..."
        }
        if self.messeng != nil {self.messeng! += "\ncode: \(code)"}
    }
}
