//
//  Row.swift
//  stores.native
//
//  Created by Takuya Yokoyama on 2019/11/06.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import Foundation

public struct Row<T>: Identifiable {
    public let id = UUID()
    public let items: [T]
    public let column: Int
    public var isFitting: Bool { items.count == column }
    public var emptyColumnCount: Int { column - items.count }
    
    public static func build(forColumn column: Int, values: [T], maxLength: Int? = nil) -> [Row<T>] {
        var values = values
        if let maxLength = maxLength {
            values = Array(values.prefix(maxLength))
        }
        let groupedItem = try? values.grouped(size: column)
        return groupedItem?.map { Row(items: $0, column: column) } ?? []
    }
}
