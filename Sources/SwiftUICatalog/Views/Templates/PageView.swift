//
//  PageView.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/11/08.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

public struct PageView<Page: View>: View {
    
    @State private var currentPage = 0
    private let viewControllers: [UIHostingController<Page>]
    private let shouldInfiniteLoop: Bool
    
    public init(views: [Page], shouldInfiniteLoop: Bool) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
        self.shouldInfiniteLoop = shouldInfiniteLoop
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(controllers: viewControllers,
                               shouldInfinitLoop: shouldInfiniteLoop,
                               currentPage: $currentPage)
            PageControl(numberOfPages: viewControllers.count,
                        currentPage: $currentPage)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(
            views: [
                Text("0"),
                Text("1"),
                Text("2"),
                Text("3"),
            ],
            shouldInfiniteLoop: true
        ).environment(\.colorScheme, .dark)
    }
}
