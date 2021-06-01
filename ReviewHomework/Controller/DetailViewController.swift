//
//  DetailViewController.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


class DetailViewController: CollectionViewController {
    
    let cellWidth = fullScreenSize.width / 4

    var viewModel = DetailViewModel()
    
    var indicatorView: UIActivityIndicatorView! = {
        let indicator = UIActivityIndicatorView(style: .white);
        indicator.color = UIColor.blue;
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true;
        return indicator;
    }();
    
    
    override func setupCollectionView() {
        super.setupCollectionView()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        
        collectionView.backgroundColor = .black
            
        let cellTypes: [UICollectionViewCell.Type] = [DetailCell.self]
        
        collectionView.register(cellTypes: cellTypes)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30+bottomPadding, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupIndicatorView()
        
        getPhotos();
    }
    
    func getPhotos() {
        indicatorView.startAnimating()
        viewModel.getPhotos { [weak self] (photos) in
            guard let self = self else { return }
            self.viewModel = DetailViewModel(photos: photos)
            
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.collectionView.reloadData();
            }
        }
    }
    
    private func setupIndicatorView() {
        view.addSubview(indicatorView)
        
        indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        indicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
    }
    
} ///class

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        viewModel.cellForIndexPath(collectionView: collectionView, indexPath);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
