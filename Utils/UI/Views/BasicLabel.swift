//
//  BasicLabel.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit

open class BasicLabel: UILabel {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init(text: String, textColor: UIColor = .black, size: CGFloat = 17, weight: UIFont.Weight = .regular) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        setupViews(text: text, textColor: textColor, size: size, weight: weight)
    }
    
    open func setupViews(text: String, textColor: UIColor = .black, size: CGFloat = 17, weight: UIFont.Weight = .regular) {
        self.textColor = textColor
        self.text = text
        self.font = UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

