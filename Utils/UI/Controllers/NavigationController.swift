//
//  NavigationController.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import UIKit


class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let navbarHeight = self.navigationBar.frame.height
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        navStatusBarHeight = navbarHeight+statusBarHeight
        
        if #available(iOS 11.0, *) {
            if let bottomSafeAreaInset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                bottomPadding = bottomSafeAreaInset
            }
        }
    }
    
}

