//
//  Array.swift
//  
//
//  Created by Takuya Yokoyama on 2019/12/07.
//

import Foundation

extension Array {
    enum GroupedError: Error, Equatable {
        case invalidArgument
        case emptyItems
    }
    
    func grouped(size: Int) throws -> [[Element]] {
        if size == 0 {
            throw GroupedError.invalidArgument
        }
        
        if self.isEmpty {
            throw GroupedError.emptyItems
        }
        
        var buffer = self
        var result = [[Element]]()
        
        while buffer.count != 0 {
            var chunk = [Element]()
            for _ in (0..<size) where buffer.count != 0 {
                chunk.append(buffer.remove(at: 0))
            }
            result.append(chunk)
            chunk = []
        }
        
        return result
    }
}
