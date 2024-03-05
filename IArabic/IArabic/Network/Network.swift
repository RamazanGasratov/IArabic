//
//  Network.swift
//  IArabic
//
//  Created by Ramazan Gasratov on 08.02.2024.
//

import Foundation

import Combine


final class Network {
    static let shared: Network = Network()
    private init() {}
}

extension Network {
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


//MARK: - NetworkManeger Combine


extension Network {

 

    // Функция аутентификации, использующая Combine
    func auth() -> AnyPublisher<String, Error> {
        let api = Api.auth // Предполагается, что у вас есть enum Api с определением endpoint'ов
        let encodeValue = AuthModel(yandexPassportOauthToken: YandexKey.key)

        guard let encodedData = try? JSONEncoder().encode(encodeValue),
              let url = URL(string: api.path) else {
            return Fail(error: StatusCode(300)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = api.method
        request.httpBody = encodedData

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw StatusCode(300)
                }
                return output.data
            }
            .decode(type: ParsingAuthData.self, decoder: JSONDecoder())
            .tryMap { parsingAuthData in
                guard let iamToken = parsingAuthData.iamToken else {
                    throw StatusCode(401)
                }
                return iamToken
            }
            .eraseToAnyPublisher()
    }

    // Обновленный метод push, использующий Combine
    func push<T: Decodable>(api: Api,
                            params: [String: String] = [:],
                            header: [String: String] = [:],
                            body: Data? = nil,
                            type: T.Type) -> AnyPublisher<T, Error> {
        let queryString = params.map { "\($0)=\($1)" }.joined(separator: "&")
        let fullPath = params.isEmpty ? api.path : "\(api.path)?\(queryString)"

        guard let url = URL(string: fullPath) else {
            return Fail(error: StatusCode(300)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = api.method
        request.httpBody = body
        header.forEach { request.addValue($1, forHTTPHeaderField: $0) }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw StatusCode()
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                // Обработка ошибок и преобразование их в тип StatusCode
                (error as? StatusCode) ?? StatusCode(error: error)
            }
            .eraseToAnyPublisher()
    }

    // Использование auth для повторного выполнения запроса после аутентификации
    func retryPushAfterAuth<T: Decodable>(apiForPush: Api,
                                          paramsForPush: [String: String],
                                          headerForPush: [String: String],
                                          bodyForPush: Data?,
                                          typeForPush: T.Type) -> AnyPublisher<T, Error> {
        auth().flatMap { iamToken -> AnyPublisher<T, Error> in
            var newHeader = headerForPush
            newHeader["Authorization"] = "Bearer \(iamToken)"
            return self.push(api: apiForPush, params: paramsForPush, header: newHeader, body: bodyForPush, type: typeForPush)
        }
        .eraseToAnyPublisher()
    }
}


extension Network {
    func translate(text: String, prefix: String) -> AnyPublisher<String, Error> {
        let model = TranslatePushModel(texts: [text], targetLanguageCode: prefix)
        guard let postData = try? JSONEncoder().encode(model) else {
            return Fail(error: StatusCode(300)).eraseToAnyPublisher()
        }

        let api = Api.translate // Убедитесь, что Api поддерживает endpoint translate
        let token = Keychain.standart.get("IamTokenKey") ?? ""
        let headers = [
            "Accept-Language": "ru",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]

        return push(api: api, params: [:], header: headers, body: postData, type: TranslateModel.self)
            .tryMap { translateModel -> String in
                guard let translation = translateModel.translations.first?.text else {
                    throw StatusCode(400) // или другой подходящий код ошибки
                }
                return translation
            }
            .eraseToAnyPublisher()
    }
}
