//
//  PageControl.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/11/08.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

struct PageControl: UIViewRepresentable {
    class Coordinator: NSObject {
        let control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
    
    typealias UIViewType = UIPageControl
    
    let numberOfPages: Int
    @Binding var currentPage: Int
    
    func makeCoordinator() -> PageControl.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<PageControl>) -> UIPageControl {
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator,
                          action: #selector(Coordinator.updateCurrentPage(sender:)),
                          for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UIPageControl, context: UIViewRepresentableContext<PageControl>) {
        uiView.currentPage = currentPage
    }
}
