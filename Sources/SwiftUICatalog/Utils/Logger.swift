//
//  Logger.swift
//
//  Created by Takuya Yokoyama on 2019/11/11.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import Foundation

public struct Logger {
    public static func info(_ message: String, prefix: String = "###") {
        print("\(prefix) \(message)")
    }
}
