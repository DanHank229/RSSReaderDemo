//
//  String+URL.swift
//  RssReaderDemo
//
//  Created by 9s on 2021/1/5.
//  Copyright © 2021 9s. All rights reserved.
//

import Foundation

extension String {
    // 將原始URL轉為合法URL
    /// If Unavailable Reture ""
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    // 將Encoded後的URL轉回原始URL
    /// If Unavailable Reture ""
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
