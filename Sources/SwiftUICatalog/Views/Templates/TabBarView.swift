//
//  TabBarView.swift
//
//  Created by Takuya Yokoyama on 2019/11/09.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI

public func TabBarView<Content>(@TabBarItemBuilder<Content> _ items: () -> [TabBarItem<Content>]) -> _TabBarView<Content> where Content: View {
    _TabBarView(items())
}

@_functionBuilder public struct TabBarItemBuilder<Content> where Content: View {
    public typealias Item = TabBarItem<Content>
    
    public static func buildBlock(_ a: Item) -> [Item] {
        [a]
    }
    
    public static func buildBlock(_ a: Item, _ b: Item) -> [Item] {
        [a, b]
    }
    
    public static func buildBlock(_ a: Item, _ b: Item, _ c: Item) -> [Item] {
        [a, b, c]
    }
    
    public static func buildBlock(_ a: Item, _ b: Item, _ c: Item, _ d: Item) -> [Item] {
        [a, b, c, d]
    }
    
    public static func buildBlock(_ a: Item, _ b: Item, _ c: Item, _ d: Item, _ e: Item) -> [Item] {
        [a, b, c, d, e]
    }
}

public struct _TabBarView<Content>: View where Content: View {
    private let items: [TabBarItem<Content>]
    
    init(_ items: [TabBarItem<Content>]) {
        self.items = items
    }
    
    public var body: some View {
        let elements = items.map { (item: TabBarItem) -> TabBarController.Element in
            let controller = UIHostingController(rootView: item.content())
            
            let tabBarItem = UITabBarItem(
                title: item.title,
                image: item.image.flatMap {
                    UIImage(systemName: $0.systemName)!
                        .scaleImage(to: $0.size) // Extension
                },
                tag: item.tag
            )
            
            return TabBarController.Element(
                controller: controller,
                tabBarItem: tabBarItem
            )
        }
        return TabBarController(elements)
            .edgesIgnoringSafeArea(.bottom)
    }
}

public struct TabBarItem<Content> where Content: View {
    public let title: String
    public let image: Image?
    public let tag: Int
    public let content: () -> Content
    
    public struct Image {
        public let systemName: String
        public let size: CGSize
        
        public init(systemName: String, size: CGSize = .init(width: 20, height: 20)) {
            self.systemName = systemName
            self.size = size
        }
    }

    public init(
        title: String,
        image: Image?,
        tag: Int,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.image = image
        self.tag = tag
        self.content = content
    }
}

private extension UIImage {
    func scaleImage(to scaleSize: CGSize) -> UIImage {
        let widthRatio = scaleSize.width / size.width
        
        
        let heightRatio = scaleSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage!
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView {
            TabBarItem(
                title: "First",
                image: .init(systemName: "heart", size: .init(width: 20, height: 20)),
                tag: 0
            ) {
                AnyView(Text("First"))
            }
            TabBarItem(
                title: "Second",
                image: .init(systemName: "heart", size: .init(width: 20, height: 20)),
                tag: 1
            ) {
                AnyView(Text("Second"))
            }
        }
    }
}

