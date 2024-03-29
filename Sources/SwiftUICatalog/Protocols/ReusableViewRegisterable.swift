//
//  ReusableViewRegisterable.swift
//
//  Created by Takuya Yokoyama on 2018/05/05.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

public protocol ReusableViewRegisterable {}

public enum UICollectionElementKind: String {
    case sectionHeader
    case sectionFooter
    
    public init(stringOf kind: String) {
        switch kind {
        case UICollectionView.elementKindSectionHeader: self = .sectionHeader
        case UICollectionView.elementKindSectionFooter: self = .sectionFooter
        default: fatalError()
        }
    }
    
    public var value: String {
        switch self {
        case .sectionHeader: return UICollectionView.elementKindSectionHeader
        case .sectionFooter: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionReusableView: ReusableViewRegisterable {}
public extension ReusableViewRegisterable where Self: UICollectionReusableView {
    static func register(for collectionView: UICollectionView,
                                ofKind kind: UICollectionElementKind,
                                bundle: Bundle? = nil) {
        let name = String(describing: Self.self)
        let nib = UINib(nibName: name, bundle: bundle)
        collectionView.register(nib, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: name)
    }
    
    static func dequeue(from collectionView: UICollectionView, ofKind kind: String, for indexPath: IndexPath) -> Self {
        return self.dequeue(from: collectionView, ofKind: UICollectionElementKind(stringOf: kind), for: indexPath)
    }
    
    static func dequeue(from collectionView: UICollectionView, ofKind kind: UICollectionElementKind, for indexPath: IndexPath) -> Self {
        let name = String(describing: Self.self)
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.value, withReuseIdentifier: name, for: indexPath) as! Self
    }
}

