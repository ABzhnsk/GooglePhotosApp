//
//  SearchViewController.swift
//  GooglePhotosApp
//
//  Created by Anna Buzhinskaya on 05.02.2023.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    struct Storyboard {
        static let showDetailSegue = "ShowDetail"
        static let numberOfItemsPerRow: CGFloat = 2.0
        static let pageNumber: Int = 0
    }
    
    var modelController: SearchModelController!
    var selectedIndexPath: IndexPath!
    
    private(set) var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        registerCollectionView()
        setupModelController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailSegue {
            let detailVC = segue.destination as! DetailViewController
            detailVC.imagesData = (sender as! [ImagesData])
            detailVC.indexPage = selectedIndexPath.row
        }
    }
}

extension SearchViewController {
    private func setupNavBar() {
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    private func setupModelController() {
        modelController.delegate = self
        modelController.fetchData(with: "Apple", page: 0)
    }
    private func registerCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.register(SearchCollectionViewCell.self,
                                     forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelController.imagesData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as? SearchCollectionViewCell
        else { return UICollectionViewCell() }
        let imageURLString = modelController.imagesData[indexPath.item].imageURLString
        let imageViewModel = ImageViewModel(imageURL: URL(string: imageURLString)!)
        cell.imageViewModel = imageViewModel
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = itemWidth(for: view.frame.width, spacing: Constants.spacing)
        return CGSize(width: width, height: width)
    }
    func itemWidth(for width: CGFloat, spacing: CGFloat) -> CGFloat {
        let itemsInRow: CGFloat = Storyboard.numberOfItemsPerRow
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow - 1) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        return floor(finalWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.spacing,
                            left: Constants.spacing,
                            bottom: Constants.spacing,
                            right: Constants.spacing)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.spacing
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imagesData = modelController.imagesData
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: Storyboard.showDetailSegue, sender: imagesData)
    }
    
}

extension SearchViewController: SearchDelegate {
    func didFinished() {
        photoCollectionView.reloadData()
    }
    func showError(with message: String) {
        print(message)
    }
}

extension SearchViewController: ZoomingViewController {
    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            let cell = photoCollectionView.cellForItem(at: indexPath) as! SearchCollectionViewCell
            return cell.imageView
        }
        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        modelController.fetchData(with: query, page: Storyboard.pageNumber)
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        modelController.fetchData(with: "Apple", page: Storyboard.pageNumber)
    }
}
