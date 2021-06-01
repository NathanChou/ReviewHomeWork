//
//  BasicImageView.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit

open class BasicImageView: UIImageView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init(myImage: UIImage? = nil) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.image = myImage
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

