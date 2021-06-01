//
//  BasicButton.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit

open class BasicButton: UIButton {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public init(text: String = "Default", backgroundColor: UIColor = .clear, titleColor: UIColor = .blue, fontSize: CGFloat = 17) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.translatesAutoresizingMaskIntoConstraints = false
        setupViews(text: text, backgroundColor: backgroundColor, titleColor: titleColor, fontSize: fontSize)
    }
    
    open func setupViews(text: String = "Default", backgroundColor: UIColor = .clear, titleColor: UIColor = .blue, fontSize: CGFloat = 17) {
        self.setTitle(text, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

