//
//  MainViewController.swift
//  ReviewHomework
//
//  Created by 周彥宏 on 2021/6/1.
//

import Foundation
import UIKit


class MainViewController: UIViewController {

    struct UI {
        static let BUTTON_SIZE: CGFloat = 18.0
        static let LABEL_SIZE: CGFloat = 17.0
        static let BTN_COLOR: UIColor = .blue
        static let LABEL_COLOR: UIColor = .white
        static let REGULAR: UIFont.Weight = .regular
        static let MEDIUM: UIFont.Weight = .medium
    }
    
    let requestButton = BasicButton(text: "Request API",
                                    titleColor: UI.BTN_COLOR,
                                    fontSize: UI.BUTTON_SIZE)
    
    let titleLabel = BasicLabel(text: "JSON Placeholder",
                                textColor: UI.LABEL_COLOR,
                                size: UI.LABEL_SIZE,
                                weight: UI.MEDIUM)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        setupLayouts()
        
        setupButton()
    }
    
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupLayouts() {
        view.addSubview(titleLabel)
        view.addSubview(requestButton)
        
        let layouts = [requestButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                       requestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                       requestButton.widthAnchor.constraint(equalToConstant: 100),
                       titleLabel.centerXAnchor.constraint(equalTo: requestButton.centerXAnchor),
                       titleLabel.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 70)]
        
        NSLayoutConstraint.activate(layouts);
    }
    
    private func setupButton() {
        requestButton.addTarget(self, action: #selector(didTapRequest(_:)), for: .touchUpInside)
    }
    
    @objc func didTapRequest(_ sender: UIButton) {
        let detailVC = DetailViewController();
        self.navigationController?.pushViewController(detailVC, animated: true);
    }
    
} ///class
