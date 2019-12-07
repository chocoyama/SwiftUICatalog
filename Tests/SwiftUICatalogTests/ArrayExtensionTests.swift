//
//  RowTests.swift
//  stores.nativeTests
//
//  Created by Takuya Yokoyama on 2019/11/06.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import XCTest
@testable import SwiftUICatalog

class ArrayExtensionTests: XCTestCase {
    
    struct TestItem: Identifiable, Equatable {
        let id = UUID()
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChunked() {
        XCTContext.runActivity(named: "itemsの件数がsizeで割り切れる場合") { _ in
            // Arrange
            let items = [
                TestItem(), TestItem(),
                TestItem(), TestItem(),
            ]

            // Act
            let actual = try! items.grouped(size: 2)

            // Assert
            let expected = [
                [items[0], items[1]],
                [items[2], items[3]],
            ]
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "itemsの件数がsizeで割り切れない場合") { _ in
            // Arrange
            let items = [
                TestItem(), TestItem(),
                TestItem(),
            ]

            // Act
            let actual = try! items.grouped(size: 2)

            // Assert
            let expected = [
                [items[0], items[1]],
                [items[2]],
            ]
            XCTAssertEqual(actual, expected)
        }
        
        XCTContext.runActivity(named: "itemsの件数がsizeに満たない場合") { _ in
            // Arrange
            let items = [
                TestItem()
            ]

            // Act
            let actual = try! items.grouped(size: 2)

            // Assert
            let expected = [
                [items[0]],
            ]
            XCTAssertEqual(actual, expected)
        }
        
        
        XCTContext.runActivity(named: "sizeが0の場合はinvalidArgumentを投げる") { _ in
            // Arrange
            let items = [TestItem()]
            
            // Act & Assert
            do {
                let _ = try items.grouped(size: 0)
                XCTFail("no expception throwed")
            } catch let error as Array<TestItem>.GroupedError {
                XCTAssertEqual(error, .invalidArgument)
            } catch {
                XCTFail("another expception throwed")
            }
        }
        
        XCTContext.runActivity(named: "itemsのsizeが0の場合はemptyItemsを投げる") { _ in
            // Arrange
            let items = [TestItem]()
            
            // Act & Assert
            do {
                let _ = try items.grouped(size: 2)
                XCTFail("no expception throwed")
            } catch let error as Array<TestItem>.GroupedError {
                XCTAssertEqual(error, .emptyItems)
            } catch {
                XCTFail("another expception throwed")
            }
        }
    }

}
