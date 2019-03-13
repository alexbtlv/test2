//
//  NetworkManager.swift
//  TestA
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

enum Response {
    case success([Recipe])
    case failure(String)
}

struct RecipeNetworkManager {
    private let router = Router<RecipeTestEndPoint>()
    
    func getRecepies(completion: @escaping (Response)->()) {
        router.request(.recepies) { (data, response, error) in
            if error != nil {
                completion(.failure("Please check your network connection."))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkResponse.noData.rawValue))
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode(RecipesWrapper.self, from: responseData)
                        completion(.success(apiResponse.recipes))
                    } catch {
                        let json = try! JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                        print(json)
                        completion(.failure(NetworkResponse.unableToDecode.rawValue))
                    }
                    
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            }
        }
    }

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}


