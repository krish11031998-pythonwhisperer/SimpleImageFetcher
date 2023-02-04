//
//  PixabayEndpoints.swift
//  VuzAssessment
//
//  Created by Krishna Venkatramani on 03/02/2023.
//

import Foundation

//MARK: - PixabayEndpoint
enum PixabayEndpoint {
    case search(q: String, limit: Int = 20, page: Int = 1)
}

//MARK: - PixabayEndpoint + APIKey
fileprivate extension PixabayEndpoint {
    var apiKey: String { "33348431-f443aba5724cb55c199b68349" }
}

//MARK: - PixabayEndpoint + Endpoint
extension PixabayEndpoint: EndPoint {
    
    var scheme: String {
        return "https"
    }
    
    var baseUrl: String {
        return "pixabay.com"
    }
    
    var path: String {
        switch self {
        case .search:
            return "/api/"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let q, let limit, let page):
            return [
                .init(name: "q", value: q),
                .init(name: "limit", value: "\(limit)"),
                .init(name: "page", value: "\(page)"),
                .init(name: "key", value: apiKey)
            ]
        }
    }
    
    var header: [String : String]? {
        return nil
    }
    
    var body: Data? {
        nil
    }
}
