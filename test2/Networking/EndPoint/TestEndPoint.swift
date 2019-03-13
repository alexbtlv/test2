//
//  TestEndPoint.swift
//  Test
//
//  Created by Alexander Batalov on 2/28/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

public enum RecipeTestEndPoint {
    case recepies
}

extension RecipeTestEndPoint: EndPointType {
    var baseURL: URL {
        return URL(string: "http://cdn.sibedge.com")!
    }
    
    var path: String {
        return "recipes.json"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .recepies:
            return .requestParameters(bodyParameters: nil, urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
