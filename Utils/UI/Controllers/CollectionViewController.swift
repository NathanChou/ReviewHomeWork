//
//  CollectionViewController.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


class CollectionViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: flowLayout)
        cv.backgroundColor = .white
        cv.alwaysBounceVertical = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var topLayout: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        topLayout = collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        
        let layouts = [collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                       collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                       collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        topLayout?.isActive = true;
        
        NSLayoutConstraint.activate(layouts)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: BaseCell.self)
    }
    
}

extension CollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: BaseCell.self, for: indexPath)
        
        return cell
    }
}

