//
//  SafariViewController.swift
//
//  Created by Takuya Yokoyama on 2019/11/07.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import SafariServices

public struct SafariViewController: UIViewControllerRepresentable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Self.Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    public func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariViewController>) {
    }
}
