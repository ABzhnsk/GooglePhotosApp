//
//  ImagesResult.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 09.02.2023.
//

import Foundation

struct ImagesResult: Codable {
    let imagesResults: [ImagesData]

    enum CodingKeys: String, CodingKey {
        case imagesResults = "images_results"
    }
}

struct ImagesData: Codable {
    let position: Int
    let thumbnail: String
    let source: String
    let title: String
    let link: String
    let imageURLString: String
    let originalWidth: Int
    let originalHeight: Int
    let isProduct: Bool
    let inStock: Bool?

    enum CodingKeys: String, CodingKey {
        case position
        case thumbnail
        case source
        case title
        case link
        case imageURLString = "original"
        case originalWidth = "original_width"
        case originalHeight = "original_height"
        case isProduct = "is_product"
        case inStock = "in_stock"
    }
}
