//
//  SearchCollectionViewCell.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 05.02.2023.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.viewCornerRadius
        contentView.addSubview(imageView)
    }
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
}

extension SearchCollectionViewCell: ReusableViewProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
