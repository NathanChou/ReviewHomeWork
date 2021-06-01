//
//  LayoutExtension.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit

extension UIView {
    
    public func addSubviews(views: [UIView]){
        views.forEach { self.addSubview($0) }
    }
    
    public func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func setCenterX(for views: UIView...){
        views.forEach { $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true }
    }
    
    public func setCenterY(for views: UIView...){
        views.forEach { $0.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true }
    }
    
    public func setLeadingForViews(views: [UIView], constant: CGFloat = 0) {
        views.forEach{ $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: constant).isActive = true }
    }
    
    public func setTrailingForViews(views: [UIView], constant: CGFloat = 0) {
        views.forEach{ $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant).isActive = true }
    }
    
    public func setTopForViews(views: [UIView], constant: CGFloat = 0) {
        views.forEach{ $0.topAnchor.constraint(equalTo: self.topAnchor, constant: constant).isActive = true }
    }
    
    
    public func setBottomForViews(views: [UIView], constant: CGFloat = 0) {
        views.forEach{ $0.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant).isActive = true }
    }
    
    public func equalWidthForViews(views: [UIView], multiplier: CGFloat = 1.0) {
        views.forEach{ $0.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true }
    }
    
    public func equalHeightForViews(views: [UIView], multiplier: CGFloat = 1.0) {
        views.forEach{ $0.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: multiplier).isActive = true }
    }
    
    public func setHuggingPriorityForViews(views: [UIView], direction: NSLayoutConstraint.Axis){
        var priority = Float(views.count + 251)
        for view in views {
            view.setContentHuggingPriority(UILayoutPriority(rawValue: priority), for: direction)
            priority -= 1
        }
    }
    
    public func setCompressionPriorityForViews(views: [UIView], direction: NSLayoutConstraint.Axis){
        var priority = Float(views.count + 750)
        for view in views {
            view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: priority), for: direction)
            priority -= 1
        }
    }
    
    public func setHeightGreaterThan(constant: CGFloat, views: UIView...){
        views.forEach { $0.heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true }
    }
    
    public func setRatioFromWidth(ratio: CGFloat = 1) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: ratio).isActive = true
    }
    
    public func setRatioFromHeight(ratio: CGFloat = 1) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: ratio).isActive = true
    }
    
}


public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

public enum AnchorEnum {
    case top, bottom, leading, trailing, none
}

extension UIView {
    
    public func fillSuperview(padding: UIEdgeInsets = .zero, lowerPriority anchor: AnchorEnum = .none) {
        translatesAutoresizingMaskIntoConstraints = false
        
        var top: NSLayoutConstraint!
        var bottom: NSLayoutConstraint!
        var leading: NSLayoutConstraint!
        var trailing: NSLayoutConstraint!
        
        if let superviewTopAnchor = superview?.topAnchor {
            top = topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top)
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottom = bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom)
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leading = leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left)
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailing = trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right)
        }
        
        switch anchor {
        case .top:
            top.priority = UILayoutPriority(999)
        case .bottom:
            bottom.priority = UILayoutPriority(999)
        case .leading:
            leading.priority = UILayoutPriority(999)
        case .trailing:
            trailing.priority = UILayoutPriority(999)
        case .none:
            break
        }
        
        NSLayoutConstraint.activate([top, bottom, leading, trailing])
    }
    
    public func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}
