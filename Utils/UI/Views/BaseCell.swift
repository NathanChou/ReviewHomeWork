//
//  BaseCell.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit

open class BaseCell: UICollectionViewCell {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    open func setupViews() {}
    
    override open func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
