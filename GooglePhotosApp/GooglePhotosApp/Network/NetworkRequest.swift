//
//  NetworkRequest.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func requestData(api: API, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard var urlComponents = URLComponents(string: api.baseURL + api.path) else {
            completion(.failure(.invalidURLError))
            return
        }
        urlComponents.queryItems = api.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURLError))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknownError))
                    return
                }
                if error != nil {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    return
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    completion(.failure(.serverError(statusCode: httpResponse.statusCode)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.invalidDataError))
                    return
                }
                completion(.success(data))
            }
        }
        .resume()
    }
}
