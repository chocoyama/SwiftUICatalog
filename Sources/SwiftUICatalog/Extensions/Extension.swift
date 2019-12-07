//
//  Extension.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import Foundation

public struct Extension<Base> {
    public let base: Base
    public init (_ base: Base) { self.base = base }
}

public protocol ExtensionCompatible {
    associatedtype Compatible
    static var ex: Extension<Compatible>.Type { get }
    var ex: Extension<Compatible> { get }
}

public extension ExtensionCompatible {
    static var ex: Extension<Self>.Type { Extension<Self>.self }
    var ex: Extension<Self> { Extension(self) }
}
