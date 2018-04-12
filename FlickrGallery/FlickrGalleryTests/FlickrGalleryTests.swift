//
//  FlickrGalleryTests.swift
//  FlickrGalleryTests
//
//  Created by 管 皓 on 2018/4/12.
//  Copyright © 2018年 Hao Guan. All rights reserved.
//

import XCTest
@testable import FlickrGallery
var testAPIParser: FlickrAPIParser!
var testGalleryCollectionViewController: GalleryCollectionViewController!

class FlickrGalleryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        testAPIParser = FlickrAPIParser()
        testGalleryCollectionViewController = GalleryCollectionViewController()
    }
    
    override func tearDown() {
        testAPIParser = nil
        testGalleryCollectionViewController = nil
        super.tearDown()
    }
    
    // test the correct return numbers of photo in correct range
    func testGeneralPageOnFlickrAPI() {
        print("Start 'GeneralPageOnFlickrAPI Test.'")
        let page = 8
        let per_page = 31
        for _ in stride(from: page, to: 40, by: 1) {
            let exp: XCTestExpectation? = expectation(description: "timeout!")
            testAPIParser.getInterestingnessList(key: api_key, date: "2018-04-11", page: page, per_page: per_page, completion: { (photos) in
                let ans = page * per_page > 500 ? 500 - (page - 1) * per_page : per_page
                XCTAssertEqual(photos.count, ans, "Didn't return correct number of photos.")
                exp?.fulfill()
            })
            waitForExpectations(timeout: 3) { (error) in
                if let _ = error {
                    print("timeout!")
                }
            }
        }
    }
    
    // nothing should be shown when the maximum number of photos reached
    func testLoadMoreWhenPageIsLargerThanTotalPage() {
        let page = 40
        let per_page = 13
        let testCount = testGalleryCollectionViewController.photos.count
        testAPIParser.getInterestingnessList(key: api_key, date: "2018-04-12", page: page, per_page: per_page) { (_) in}
        XCTAssertEqual(testCount, 0, "Page 40 is greater than the largest page, nothing should be added into photos")
    }
}
