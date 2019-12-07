//
//  UIApplication+.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import UIKit

public extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }

}

