//
//  CollectionViewExtension.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


public extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
    
}


public extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        if Bundle.main.path(forResource: className, ofType: "nib") != nil {
            // register for nib
            let nib = UINib(nibName: className, bundle: nil)
            register(nib, forCellWithReuseIdentifier: className)
        } else {
            // register for class
            register(cellType, forCellWithReuseIdentifier: className)
        }
    }
    
    func register<T: UICollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
    func cellForItem<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T? {
        return cellForItem(at: indexPath) as? T
    }
    
    func dynamicHeightOn() {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
    }
    
    var contentHeight: CGFloat {
        return collectionViewLayout.collectionViewContentSize.height + contentInset.top + contentInset.bottom
    }
}

