//
//  Network.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 08.02.2024.
//

import Foundation
import KeychainSwift

class Keychain {
    static var standart: KeychainSwift = KeychainSwift()
    private init() {}
}

final class Network {
    static var shared: Network = Network()
    private init() {}
    
    func push<T: Decodable>(api: Api,
                            params: [String: String] = [:],
                            header: [String: String] = [:],
                            body: Data? = nil,
                            type: T.Type,
                            completion: @escaping (Result<T>) -> ()) {
        
        let string = params.map { $0 + "=" + $1}.joined(separator: "&")
        let path = params.isEmpty ? api.path : (api.path + "?" + string)
        
        
        guard let url = URL(string: path) else {return completion(Result.failur(error: StatusCode(300)))}
        
        var request =  URLRequest(url: url, timeoutInterval: .infinity)
        request.timeoutInterval = 10
        request.httpMethod = api.method
        request.httpBody = body
        
        header.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            guard let data = data, let responce = responce as? HTTPURLResponse else {return completion(Result.failur(error: StatusCode(error: error)))
            }
//            let str = String(decoding: data, as: UTF8.self)
//            print(str)
            
            
            let code = responce.statusCode
            
            let decode = JSONDecoder()
            guard let value = try? decode.decode(type.self, from: data) else {
                switch code {
                case 401:
                    self.auth(apiForPush: api,
                              paramsForPush: params,
                              headerForPush: header,
                              bodyiForPush: body,
                              typeiForPush: type,
                              completion: completion)
                default:
                    return completion(Result.failur(error: StatusCode(code)))
                }
                return
            }
            return completion(Result.succes(model: value))
        }
        task.resume()
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

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


enum Result<Model> {
    case succes(model: Model)
    case failur(error: StatusCode)
}


extension Network {
    
    struct AuthModel: Encodable {
        let yandexPassportOauthToken: String
    }
    
    struct ParsingAuthData: Decodable {
        let iamToken: String?
    }
    
    func auth<T: Decodable>(apiForPush: Api,
                            paramsForPush: [String: String],
                            headerForPush: [String: String],
                            bodyiForPush: Data?,
                            typeiForPush: T.Type,
                            completion: @escaping (Result<T>) -> ()){
        
        let api = Api.auth
        
        let encodeValue = AuthModel(yandexPassportOauthToken: YandexKey.key)
        let encodaData = try? JSONEncoder().encode(encodeValue)
        
        guard let url = URL(string: api.path) else {return completion(Result.failur(error: StatusCode(300)))}
        
        var request =  URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = api.method
        request.httpBody = encodaData
        
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            
            guard let data = data, let responce = responce as? HTTPURLResponse else{
                return completion(Result.failur(error: StatusCode(error: error)))
            }
            
            let code = responce.statusCode
            
            let decode = JSONDecoder()
            
            guard let value = try? decode.decode(ParsingAuthData.self, from: data), let token = value.iamToken else {
                return completion(Result.failur(error: StatusCode(code)))
            }
            Keychain.standart.set(token, forKey: "IamTokenKey")
          
            var newHeader = headerForPush
            newHeader["Authorization"] = "Bearer " + token
            self.finishPush(api: apiForPush,
                            params: paramsForPush,
                            header: newHeader,
                            body: bodyiForPush,
                            type: typeiForPush,
                            completion: completion)
            
        }
        task.resume()
    }
    
    
    
    
    
    private func finishPush<T: Decodable>(api: Api,
                                          params: [String: String],
                                          header: [String: String],
                                          body: Data?,
                                          type: T.Type,
                                          completion: @escaping (Result<T>) -> ()) {
        
        let string = params.map { $0 + "=" + $1}.joined(separator: "&")
        let path = params.isEmpty ? api.path : (api.path + "?" + string)
        
        
        guard let url = URL(string: path) else {return completion(Result.failur(error: StatusCode(300)))}
        
        var request =  URLRequest(url: url, timeoutInterval: .infinity)
        request.timeoutInterval = 10
        request.httpMethod = api.method
        request.httpBody = body
        
        header.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, responce, error in
            guard let data = data, let responce = responce as? HTTPURLResponse else {return completion(Result.failur(error: StatusCode(error: error)))
            }
            
            let code = responce.statusCode
            
            let decode = JSONDecoder()
            guard let value = try? decode.decode(type.self, from: data) else {
                //TODO: доделать ошибку
                return completion(Result.failur(error: StatusCode(code)))
            }
            return completion(Result.succes(model: value))
        }
        task.resume()
    }
}




extension Network {
    struct TranslatePushModel: Codable {
        let folderId: String
        let texts: [String]?
        let targetLanguageCode: String?
        
        init(texts: [String]? = nil, targetLanguageCode: String? = nil) {
            self.folderId = YandexKey.folderID
            self.texts = texts
            self.targetLanguageCode = targetLanguageCode
        }
    }
    
    
    func translate(text: String, prefix: String, completion: @escaping (String?, StatusCode) -> ()) {
        
        let model = TranslatePushModel(texts: [text], targetLanguageCode: prefix)
        let postData = try? JSONEncoder().encode(model)
        let api = Api.translate
        
        //key
        let token = Keychain.standart.get("IamTokenKey") ?? ""
        
        let headers = [
            "Accept-Language": "ru",
            "Content-Type": "application/json",
            "Authorization": "Bearer " + token
        ]
        
        push(api: api, params: [:], header: headers, body: postData, type: TranslateModel.self) { result in
            switch result {
            case .succes(let model):
                let text = model.translations.first?.text
                completion(text, StatusCode())
            case .failur(let error):
                completion(nil, error)
            }
        }
    }
}


struct TranslateModel: Codable {
    let translations: [Translation]
}

// MARK: - Translation
struct Translation: Codable {
    let text: String?                 //само слово перевода
    let detectedLanguageCode: String? //prefix
}
