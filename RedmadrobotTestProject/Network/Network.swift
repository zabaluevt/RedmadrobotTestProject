//
//  Network.swift
//  RedmadrobotTestProject
//
//  Created by Тимофей Забалуев on 17.12.2019.
//  Copyright © 2019 Тимофей Забалуев. All rights reserved.
//

import Foundation
import Alamofire

public class Network {
    static func get<T: Decodable>(type: T.Type,
                                  url: String = Settings.mainUrl,
                                  urlParams: String = "",
                                  queryParams: [String: String],
                                  completHandler: @escaping ((_ output: T) -> Void),
                                  errorHandler: @escaping ((_ error: Error) -> Void)) {
        let clientId = Settings.apiKey
        let params = queryParams.merging(["client_id" : clientId], uniquingKeysWith: {(current, _) in current })
        let dataRequest = AF.request(url + urlParams,
                                     method: .get,
                                     parameters: params,
                                     encoding: URLEncoding.default,
                                     headers: nil,
                                     interceptor: nil)
        
        dataRequest.responseData(completionHandler: { (dataResponse) in
            if let error = dataResponse.error {
                errorHandler(error)
                return
            }
            
            guard let data = dataResponse.data else { return }
            let decoder = JSONDecoder()
            do {
                let output = try decoder.decode(T.self, from: data)
                completHandler(output)
            }
            catch (let error) {
                errorHandler(error)
            }
        })
    }
}

