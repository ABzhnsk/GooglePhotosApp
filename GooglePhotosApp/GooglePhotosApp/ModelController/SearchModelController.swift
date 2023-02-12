//
//  SearchModelController.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import UIKit

protocol SearchDelegate: AnyObject {
    func didFinished()
    func showError(with message: String)
}

class SearchModelController {
    weak var delegate: SearchDelegate?
    var imagesData = [ImagesData]()
    
    private let network = NetworkDataFetch.shared
    
    func fetchData(with query: String, page: Int) {
        network.fetchPhoto(api: .getSearch(query: query, page: page)) { [weak self] result in
            switch result {
            case .success(let photos):
                print("IMAGES: \(photos)")
                self?.imagesData = photos
                self?.delegate?.didFinished()
            case .failure(let error):
                print("ERROR: \(error)")
                self?.delegate?.showError(with: error.errorDescription)
            }
        }
    }
}
