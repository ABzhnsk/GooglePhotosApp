//
//  APIError.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import Foundation

enum APIError: Error {
    case invalidURLError
    case invalidDataError
    case serverError(statusCode: Int)
    case unknownError
    case decodeError
    
    var errorDescription: String {
        switch self {
        case .invalidURLError:
            return "The URL is invalid"
        case .invalidDataError:
            return "Data is not valid"
        case .serverError(let statusCode):
            return "\(statusCode) server error"
        case .unknownError:
            return "Unknown Error"
        case .decodeError:
            return "Decode Error"
        }
    }
}
