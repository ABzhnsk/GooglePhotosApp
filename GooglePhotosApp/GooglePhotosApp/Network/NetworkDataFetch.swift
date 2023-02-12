//
//  NetworkDataFetch.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import Foundation

class NetworkDataFetch {
    static let shared = NetworkDataFetch()
    
    private init() {}
    
    func fetchPhoto(api: API, response: @escaping (Result<[ImagesData], APIError>) -> Void) {
        NetworkRequest.shared.requestData(api: api) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(ImagesResult.self, from: data)
                    print("JSON DATA: \(jsonData)")
                    response(.success(jsonData.imagesResults))
                } catch {
                    response(.failure(.decodeError))
                }
            case .failure(_):
                response(.failure(.invalidDataError))
            }
        }
    }
}
