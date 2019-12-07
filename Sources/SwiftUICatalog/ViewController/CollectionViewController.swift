//
//  CollectionViewController.swift
//
//  Created by 横山 拓也 on 2019/11/12.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import SwiftUI
import UIKit

public struct Collection<Section: Hashable, Item: Hashable> {
    public let section: Section
    public let items: [Item]
    
    public init(section: Section, items: [Item]) {
        self.section = section
        self.items = items
    }
}

public struct ItemContainer<Section: Hashable, Item: Hashable>: Hashable {
    public let section: Section
    public let item: Item
}

public struct CollectionViewController<Section: Hashable, Item: Hashable, Content>: UIViewControllerRepresentable where Content: View {
    private let collections: [Collection<Section, Item>]
    private let collectionViewLayout: UICollectionViewLayout
    private let viewController: UICollectionViewController
    private var onSelect: ((ItemContainer<Section, Item>) -> Void)?
    private var onScroll: ((Double) -> Void)?
    private let content: (ItemContainer<Section, Item>) -> Content
    
    public init(
        collections: [Collection<Section, Item>],
        layout: UICollectionViewLayout,
        @ViewBuilder content: @escaping (ItemContainer<Section, Item>) -> Content
    ) {
        self.collections = collections
        self.collectionViewLayout = layout
        self.viewController = UICollectionViewController(collectionViewLayout: layout)
        self.onSelect = nil
        self.onScroll = nil
        self.content = content
    }
    
    public func makeCoordinator() -> CollectionViewController.Coordinator {
        Coordinator(self, collectionView: viewController.collectionView!, content: content, onSelect: onSelect, onScroll: onScroll)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CollectionViewController>) -> UICollectionViewController {
        viewController.collectionView.dataSource = context.coordinator
//        viewController.collectionView.dataSource = context.coordinator.dataSource
        viewController.collectionView.delegate = context.coordinator
        viewController.collectionView.alwaysBounceVertical = true
        viewController.collectionView.backgroundColor = .systemBackground
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UICollectionViewController, context: UIViewControllerRepresentableContext<CollectionViewController>) {
        context.coordinator.collections = collections
        if !collections.isEmpty {
            uiViewController.collectionView.reloadData()
//            uiViewController.collectionView.reloadItems(at: uiViewController.collectionView.indexPathsForVisibleItems)
        }
        
//        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemContainer<Section, Item>>()
//        snapshot.appendSections(collections.map { $0.section })
//        collections.forEach { collection in
//            let itemContainers = collection.items.map { ItemContainer(section: collection.section, item: $0) }
//            snapshot.appendItems(itemContainers, toSection: collection.section)
//        }
//        context.coordinator.dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    public func onSelect(perform action: @escaping (ItemContainer<Section, Item>) -> Void) -> Self {
        var collectionView = CollectionViewController(collections: collections, layout: collectionViewLayout, content: content)
        collectionView.onSelect = action
        collectionView.onScroll = onScroll
        return collectionView
    }
    
    public func onScroll(perform action: @escaping (Double) -> Void) -> Self {
        var collectionView = CollectionViewController(collections: collections, layout: collectionViewLayout, content: content)
        collectionView.onSelect = onSelect
        collectionView.onScroll = action
        return collectionView
    }
}

extension CollectionViewController {
    public class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        let collectionViewController: CollectionViewController
        var collections: [Collection<Section, Item>] = []
//        let dataSource: UICollectionViewDiffableDataSource<Section, ItemContainer<Section, Item>>
        let content: (ItemContainer<Section, Item>) -> Content
        let onSelect: ((ItemContainer<Section, Item>) -> Void)?
        let onScroll: ((Double) -> Void)?
        
        init(
            _ collectionViewController: CollectionViewController,
            collectionView: UICollectionView,
            content: @escaping (ItemContainer<Section, Item>) -> Content,
            onSelect: ((ItemContainer<Section, Item>) -> Void)?,
            onScroll: ((Double) -> Void)?
        ) {
            self.collectionViewController = collectionViewController
            self.content = content
            self.onSelect = onSelect
            self.onScroll = onScroll
            
            let cellIdentifier = "CollectionViewCell"
            collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
//            dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, itemContainer) -> UICollectionViewCell? in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
//                let content = UIHostingController(rootView: content(itemContainer)).view!
//                cell.set(content: content)
//                return cell
//            }
        }
        
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            collections.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            collections[section].items.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            let rootView = content(itemContainer(at: indexPath))
            let content = UIHostingController(rootView: rootView).view!
            cell.set(content: content)
            return cell
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            onSelect?(itemContainer(at: indexPath))
//            guard let itemContainer = dataSource.itemIdentifier(for: indexPath) else { return }
//            onSelect?(itemContainer)
        }
        
        private func itemContainer(at indexPath: IndexPath) -> ItemContainer<Section, Item> {
            let collection = collections[indexPath.section]
            return ItemContainer(section: collection.section, item: collection.items[indexPath.item])
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let collectionView = scrollView as? UICollectionView else { return }
            let height = collectionView.contentSize.height
            let y = collectionView.contentOffset.y + collectionView.frame.height
            let offsetPercentage = y / height
            onScroll?(Double(offsetPercentage))
        }
    }
}
