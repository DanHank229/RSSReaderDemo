//
//  DebugPrint.swift
//  RssReaderDemo
//
//  Created by 9s on 2020/12/28.
//  Copyright © 2020 9s. All rights reserved.
//

import Foundation

class Debug  {
    static func println<T>(msg: T, fileName: String = #fileID, function: String = #function, line: Int = #line) {
        #if DEBUG
        let file = (fileName as NSString ).lastPathComponent
//        print("\(file).\(line) - \(function): \(msg)")
        print("\(msg)           (in \(file).\(line) - \(function))")
        #endif
    }
}
