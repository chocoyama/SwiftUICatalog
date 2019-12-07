//
//  PageViewController.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/11/08.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit
import SwiftUI

struct PageViewController: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let parent: PageViewController
        let shouldInifiniteLoop: Bool
        
        init(_ pageViewController: PageViewController, shouldInifiniteLoop: Bool) {
            self.parent = pageViewController
            self.shouldInifiniteLoop = shouldInifiniteLoop
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            if index == 0 {
                return shouldInifiniteLoop ? parent.controllers.last : nil
            } else {
                return parent.controllers[index - 1]
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            if index + 1 == parent.controllers.count {
                return shouldInifiniteLoop ? parent.controllers.first : nil
            } else {
                return parent.controllers[index + 1]
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let index = parent.controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
    
    typealias UIViewControllerType = UIPageViewController
    
    let controllers: [UIViewController]
    let shouldInfinitLoop: Bool
    @Binding var currentPage: Int
    
    func makeCoordinator() -> PageViewController.Coordinator {
        Coordinator(self, shouldInifiniteLoop: shouldInfinitLoop)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PageViewController>) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ uiViewController: UIPageViewController, context: UIViewControllerRepresentableContext<PageViewController>) {
        uiViewController
            .setViewControllers([controllers[currentPage]], direction: .forward, animated: true)
    }
}
