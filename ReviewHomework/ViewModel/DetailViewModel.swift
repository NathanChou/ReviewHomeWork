//
//  DetailViewModel.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


struct DetailViewModel {
    
    private var photos: [PhotosModel]
    
    var lastIndex: Int {
        return photos.count-1
    }
    
    func numberOfRows() -> Int {
        return photos.count
    }
    
    func modelAtRows(_ rows: Int) -> PhotosModel {
        return photos[rows]
    }
    
    
    mutating func cellForIndexPath(collectionView: UICollectionView,
                                   _ indexPath: IndexPath) -> DetailCell {
        
        let model = modelAtRows(indexPath.row)
        
        var cell: DetailCell!
        
        cell = collectionView.dequeueReusableCell(with: DetailCell.self, for: indexPath);
        
        cell.update(with: model)
        
        return cell
    }
    
    
    mutating func append(_ photo: PhotosModel) {
        self.photos.append(photo)
    }
    
    init() {
        self.photos = []
    }
    
    init(photos: [PhotosModel]) {
        self.photos = photos
    }
    
    func getPhotos(completion: @escaping([PhotosModel]) -> Void) {
        NetworkManager.sharedInstance.fetchPhotos { (photos) in
            completion(photos)
        }
    }
}


