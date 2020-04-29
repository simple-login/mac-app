//
//  SLApiService.swift
//  Simple Login
//
//  Created by Thanh-Nhon Nguyen on 03/01/2020.
//  Copyright © 2020 SimpleLogin. All rights reserved.
//

import Foundation
import Alamofire

final class SLApiService {
    static func fetchUserInfo(apiKey: ApiKey, completion: @escaping (Result<UserInfo, SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        
        AF.request("\(BASE_URL)/api/user_info", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 200:
                do {
                    let userInfo = try UserInfo(fromData: data)
                    completion(.success(userInfo))
                } catch let error as SLError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.unknownError(error: error)))
                }
                
            case 401: completion(.failure(.invalidApiKey))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
    
    static func fetchUserOptions(apiKey: ApiKey, hostname: String? = nil, completion: @escaping (Result<UserOptions, SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        
        let urlString: String
        if let hostname = hostname {
            urlString = "\(BASE_URL)/api/v3/alias/options?hostname=\(hostname)"
        } else {
            urlString = "\(BASE_URL)/api/v3/alias/options"
        }
        
        AF.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 200:
                do {
                    let userOptions = try UserOptions(fromData: data)
                    completion(.success(userOptions))
                } catch let error as SLError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.unknownError(error: error)))
                }
                
            case 401: completion(.failure(.invalidApiKey))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
    
    static func createAlias(apiKey: ApiKey, prefix: String, suffix: String, note: String?, completion: @escaping (Result<Alias, SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        var parameters = ["alias_prefix" : prefix, "alias_suffix" : suffix]
        
        if let note = note {
            parameters["note"] = note
        }
        
        AF.request("\(BASE_URL)/api/alias/custom/new", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 201:
                guard let data = response.data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                    if let jsonDictionary = jsonDictionary {
                        do {
                            let alias = try Alias(fromDictionary: jsonDictionary)
                            completion(.success(alias))
                        } catch let error as SLError {
                            completion(.failure(error))
                        }
                    }
                    
                } catch {
                    completion(.failure(.failToSerializeJSONData))
                }
                
            case 401: completion(.failure(.invalidApiKey))
            case 409: completion(.failure(.duplicatedAlias))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
    
    static func randomAlias(apiKey: ApiKey, completion: @escaping (Result<Alias, SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        
        AF.request("\(BASE_URL)/api/alias/random/new", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 201:
                guard let data = response.data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                    if let jsonDictionary = jsonDictionary {
                        do {
                            let alias = try Alias(fromDictionary: jsonDictionary)
                            completion(.success(alias))
                        } catch let error as SLError {
                            completion(.failure(error))
                        }
                    }
                    
                } catch {
                    completion(.failure(.failToSerializeJSONData))
                }
                
            case 401: completion(.failure(.invalidApiKey))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
    
    static func fetchAliases(apiKey: ApiKey, page: Int, searchTerm: String? = nil, completion: @escaping (Result<[Alias], SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        
        let method: HTTPMethod
        let parameters: [String: Any]?
        if let searchTerm = searchTerm {
            parameters = ["query": searchTerm]
            method = .post
        } else {
            parameters = nil
            method = .get
        }
        
        
        AF.request("\(BASE_URL)/api/v2/aliases?page_id=\(page)", method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 200:
                guard let data = response.data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                    
                    if let aliasDictionaries = jsonDictionary?["aliases"] as? [[String : Any]] {
                        var aliases: [Alias] = []
                        try aliasDictionaries.forEach { (dictionary) in
                            do {
                                try aliases.append(Alias(fromDictionary: dictionary))
                            } catch let error as SLError {
                                completion(.failure(error))
                                return
                            }
                        }
                        
                        completion(.success(aliases))
                        
                    } else {
                        completion(.failure(.failToSerializeJSONData))
                    }
                    
                } catch {
                    completion(.failure(.failToSerializeJSONData))
                }
                
            case 400: completion(.failure(.badRequest(description: "page_id must be provided in request query.")))
            case 401: completion(.failure(.invalidApiKey))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
    
    static func processPayment(apiKey: ApiKey, receiptData: String, completion: @escaping (Result<Any?, SLError>) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]
        let parameters: [String : Any] = ["receipt_data": receiptData, "is_macapp": true]
        
        AF.request("\(BASE_URL)/api/apple/process_payment", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response { response in
            
            guard let statusCode = response.response?.statusCode else {
                completion(.failure(.unknownResponseStatusCode))
                return
            }
            
            switch statusCode {
            case 200: completion(.success(nil))
            case 401: completion(.failure(.invalidApiKey))
            case 500: completion(.failure(.internalServerError))
            case 502: completion(.failure(.badGateway))
            default: completion(.failure(.unknownErrorWithStatusCode(statusCode: statusCode)))
            }
        }
    }
}
