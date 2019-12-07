//
//  UIView+.swift
//
//  Created by Takuya Yokoyama on 2019/12/01.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

extension UIView: ExtensionCompatible {}
public extension Extension where Base: UIView {
    func overlay(on view: UIView) {
        view.addSubview(base)
        base.translatesAutoresizingMaskIntoConstraints = false
        base.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        base.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        base.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        base.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func overlay(on view: UIView, insets: UIEdgeInsets) {
        view.addSubview(base)
        base.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            base.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            base.leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            base.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right),
            base.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
            ])
    }
}
