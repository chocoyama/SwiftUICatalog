//
//  TabBarController.swift
//
//  Created by Takuya Yokoyama on 2019/11/09.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

struct TabBarController: UIViewControllerRepresentable {
    struct Element {
        let controller: UIViewController
        let tabBarItem: UITabBarItem
    }
    
    private let elements: [Element]
    
    init(_ elements: [Element]) {
        self.elements = elements
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarController>) -> UITabBarController {
        var controllers = [UIViewController]()
        elements.forEach {
            $0.controller.tabBarItem = $0.tabBarItem
            controllers.append($0.controller)
        }
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers(controllers, animated: false)
        return tabBarController
    }
    
    func updateUIViewController(_ uiViewController: UITabBarController, context: UIViewControllerRepresentableContext<TabBarController>) {}
}
