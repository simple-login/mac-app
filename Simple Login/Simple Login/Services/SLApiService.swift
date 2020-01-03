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
    static func checkApiKey(_ apiKey: String, completion: @escaping (_ isValid: Bool) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]

        AF.request("\(BASE_URL)/api/alias/options", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { response in

            switch response.response?.statusCode {
            case 200: completion(true)
            default: completion(false)
            }
        }
    }
    
    static func fetchUserData(apiKey: String, hostname: String, completion: @escaping (_ user: User?, _ error: SLError?) -> Void) {
        let headers: HTTPHeaders = ["Authentication": apiKey]

        AF.request("\(BASE_URL)/api/alias/options?hostname=\(hostname)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).response { response in

            guard let data = response.data else {
                completion(nil, SLError.noData)
                return
            }
            
            switch response.response?.statusCode {
            case 200:
                do {
                    let user = try User(fromData: data)
                    completion(user, nil)
                } catch let error {
                    completion(nil, error as? SLError)
                }
            case 401: completion(nil, SLError.invalidApiKey)
            default: completion(nil, SLError.unknownError(description: "error code \(String(describing: response.response?.statusCode))"))
            }
        }
    }
}
