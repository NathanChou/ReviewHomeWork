//
//  DetailCell.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


class DetailCell: BaseCell {
    
    let idLabel = BasicLabel(text: "", textColor: .white, size: 17, weight: .medium)
    
    let titleLabel = BasicLabel(text: "", textColor: .white, size: 14, weight: .medium)
    
    let photoImageView = BasicImageView(myImage: nil);
    
    let indicatorView: UIActivityIndicatorView! = {
        let indicator = UIActivityIndicatorView(style: .white);
        indicator.color = UIColor.blue;
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true;
        return indicator;
    }();
    
    
    var photoId: Int = 0
    
    override func setupViews() {
        super.setupViews()
        
        setupLayouts()
    }
    
    private func setupLayouts() {
        photoImageView.contentMode = .scaleAspectFit
        
        addSubview(photoImageView)
        
        photoImageView.fillSuperview();
        
        photoImageView.addSubviews(views: [idLabel, titleLabel])
        
        setCenterX(for: idLabel, titleLabel)
        
        idLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8).isActive = true;
        idLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -3).isActive = true;
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3).isActive = true
        
        [idLabel, titleLabel].forEach({
            $0.numberOfLines = 1
        })
        
        addSubview(indicatorView)
        
        indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
        indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true;
        indicatorView.startAnimating()
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
        super.prepareForReuse()
    }
    
    func update(with photo: PhotosModel) {
        self.photoId = photo.id
        
        idLabel.text = "\(photo.id)"
        
        titleLabel.text = photo.title
        
        guard let url = URL(string: photo.thumbnailUrl) else { return }
        
        NetworkManager.sharedInstance.fetchImage(url: url) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                if photo.id == self.photoId {
                    DispatchQueue.main.async {
                        self.photoImageView.image = image
                        self.indicatorView.stopAnimating();
                    }
                }
            case .failure(let error):
                print(error.localizedDescription);
            }
        }
    }
}
