//
//  UIApplication+.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import UIKit

extension UIApplication: ExtensionCompatible {}
public extension Extension where Base: UIApplication {
    func hideKeyboard() {
        base.sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil)
    }
    
    var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first
    }
    
    var rootViewController: UIViewController? {
        keyWindow?.rootViewController
    }
}

