//
//  API.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import Foundation

enum API {
    enum HTTPMethod: String {
        case get = "GET"
    }
    case getSearch(query: String, page: Int)
    
    var method: HTTPMethod {
        return .get
    }
    var baseURL: String {
        return "https://serpapi.com"
    }
    var path: String {
        switch self {
        case .getSearch:
            return "/search.json"
        }
    }
    var query: [String: String] {
        switch self {
        case let .getSearch(query, page):
            return ["q": query, "tbm": "isch", "ijn": "\(page)", "api_key": Secrets.apiKey]
        }
    }
}
