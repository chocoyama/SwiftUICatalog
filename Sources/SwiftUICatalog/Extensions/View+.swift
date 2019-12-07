//
//  View+.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import SwiftUI

extension View {
    func fittingHeight() -> CGFloat {
        let uiView = UIHostingController(rootView: self).view!
        let size = uiView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
        return size.height
    }
}
