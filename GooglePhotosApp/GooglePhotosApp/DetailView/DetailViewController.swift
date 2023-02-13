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
    
    struct Storyboard {
        static let showDetailSegue = "ShowWebView"
    }
    
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
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if (indexPage + 1) < imagesData.count {
            indexPage += 1
        } else {
            indexPage = 0
        }
        loadElements()
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        if (indexPage - 1) >= 0 {
            indexPage -= 1
        } else {
            indexPage = imagesData.count - 1
        }
        loadElements()
    }
}

extension DetailViewController {
    private func loadElements() {
        let images = imagesData[indexPage]
        let imageURLString = images.imageURLString
        guard let imageURL = URL(string: imageURLString) else { return }
        imageViewModel = ImageViewModel(imageURL: imageURL)
        setupLinkLabel(with: images.source)
    }
    private func setupLinkLabel(with text: String) {
        linkLabel.text = text
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.link, range: range)
        linkLabel.attributedText = underlineAttriString
        linkLabel.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapLabel(gesture:)))
        linkLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapLabel(gesture: UITapGestureRecognizer) {
        let source = imagesData[indexPage].link
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.sourceURL = source
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}

extension DetailViewController: ZoomingViewController {
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        return imageView
    }
}
