//
//  ImageViewModel.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 12.02.2023.
//

import UIKit
import SDWebImage

class ImageViewModel {
    let imageURL: URL
    private var image: UIImage?

    init(imageURL: URL) {
        self.imageURL = imageURL
    }

    func getImage(completion: @escaping (UIImage?) -> Void) {
        if let image = image {
            completion(image)
        } else {
            SDWebImageManager.shared.loadImage(with: imageURL,
                                               options: .continueInBackground,
                                               progress: nil) { (image, _, _, _, _, _) in
                completion(image)
            }
        }
    }
}
