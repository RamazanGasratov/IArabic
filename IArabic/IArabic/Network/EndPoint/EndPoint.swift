//
//  EndPoint.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 05.03.2024.
//

import Foundation

enum Api {
    case words
    case translate
    case languages
    case auth
    case unsplash
    
    private var defaultURLYandex: String { return "https://translate.api.cloud.yandex.net/translate/v2/" }
    
    //MARK: - PATH
    var path: String {
        switch self {
        case .words:     return "http://80.78.253.225/html/api/words.php"
        case .translate: return defaultURLYandex + "translate"
        case .auth:      return "https://iam.api.cloud.yandex.net/iam/v1/tokens"
        case .languages: return defaultURLYandex + "languages"
        case .unsplash:  return "https://api.unsplash.com/search/collections"
        }
    }
    
    //MARK: - METHOD
    var method: String {
        switch self {
        case .words:     return HTTPMethod.get.rawValue
        case .translate: return HTTPMethod.post.rawValue
        case .auth:      return HTTPMethod.post.rawValue
        case .languages: return HTTPMethod.post.rawValue
        case .unsplash:  return HTTPMethod.get.rawValue
        }
    }
}
