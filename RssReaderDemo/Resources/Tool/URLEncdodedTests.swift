//
//  URLEncdodedTests.swift
//  RssReaderDemoTests
//
//  Created by 9s on 2021/1/5.
//  Copyright © 2021 9s. All rights reserved.
//

import XCTest
@testable import RssReaderDemo

class URLEncdodedTests: XCTestCase {

    func testURLEncoded() {
        let url = "https://franksios.medium.com/ios-%E9%81%B8%E5%96%AE-side-menu-without-storyboard-b89c9f6adba5"
        let urlChinese = "https://franksios.medium.com/ios-選單-side-menu-without-storyboard-b89c9f6adba5"
//        let urlSpecial = "https://franksios.medium.com/ios-%E9%81%B8%E5%96%AE-side-menu-without-storyboard-b89c9f6adba5 "
        let urlSpecialTail = "https://franksios.medium.com/ios-%E9%81%B8%E5%96%AE-side-menu-without-storyboard-b89c9f6adba 5"
        
        // 直接轉換
        XCTAssertTrue(stringToUrl(urlString: url))
        XCTAssertFalse(stringToUrl(urlString: urlChinese))
        XCTAssertFalse(stringToUrl(urlString: urlSpecialTail))
        
        // 合法化後轉換
        XCTAssertTrue(urlAvailable(urlString: url))
        XCTAssertTrue(urlAvailable(urlString: urlChinese))
        XCTAssertTrue(urlAvailable(urlString: urlSpecialTail))
    }
    
    /// 確認URL是可用的
    func urlAvailable(urlString: String) -> Bool {
        let url = urlString.urlEncoded()
        return stringToUrl(urlString: url)
    }
    
    /// string轉為URL
    func stringToUrl(urlString: String) -> Bool {
        if URL(string: urlString) != nil {
            return true
        } else {
            return false
        }
    }
}
