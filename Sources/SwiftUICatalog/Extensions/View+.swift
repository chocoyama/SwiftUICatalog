//
//  View+.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import SwiftUI

extension View {
    static var ex: Extension<Self>.Type { Extension<Self>.self }
    var ex: Extension<Self> { Extension(self) }
}

public extension Extension where Base: View {
    func fittingHeight() -> CGFloat {
        let uiView = UIHostingController(rootView: base).view!
        let size = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
        return size.height
    }
}
