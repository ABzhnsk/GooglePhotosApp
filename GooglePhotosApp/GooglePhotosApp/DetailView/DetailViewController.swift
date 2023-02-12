//
//  DetailViewController.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 11.02.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var imageViewModel: ImageViewModel? {
        didSet {
            imageView.image = nil
            imageViewModel?.getImage { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            }
        }
    }
    
    var imagesData: [ImagesData]!
    var indexPage: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadElements()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        linkLabel.removeFromSuperview()
        nextButton.removeFromSuperview()
        prevButton.removeFromSuperview()
    }
}

extension DetailViewController {
    private func loadElements() {
        let images = imagesData[indexPage]
        let imageURLString = images.imageURLString
        imageViewModel = ImageViewModel(imageURL: URL(string: imageURLString)!)
        linkLabel.text = images.source
    }
}

extension DetailViewController: ZoomingViewController {
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return view
    }
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return imageView
    }
}
