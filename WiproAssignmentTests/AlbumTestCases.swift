//
//  AlbumTestCases.swift
//  WiproAssignmentTests
//
//  Created by Harsha Gunaki on 16/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import XCTest
@testable import WiproAssignment

class  AlbumTestCases: XCTestCase {

    func testEmptySearchText()  {
        let vm = AlbumSearchViewModel(searchTerm: "")
        XCTAssertEqual(vm.isValidSearchString(), false)
    }
    
    func testValidSearchText()  {
         let vm = AlbumSearchViewModel(searchTerm: "Believe")
         XCTAssertEqual(vm.isValidSearchString(), true)
    }
    
    func testSearchAlbumAPI(){
        let vm = AlbumSearchViewModel(searchTerm: "Believe")
        let expectation = XCTestExpectation(description: "searchResults")
        vm.searchAlbum({ (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data.results?.albummatches.album.isEmpty)
            case .error(let error):
               XCTFail("\(error)")
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 20)
    }
    
    func testAlbumDetailAPI(){
        let vm = AlbumDetailViewModel.init(album: "Believe", artist: "Cher")
         let expectation = XCTestExpectation(description: "albumDetail")
         vm.getAlbumInfo({ (result) in
             switch result {
             case .success(let data):
                 XCTAssertNotNil(data.album)
             case .error(let error):
                XCTFail("\(error)")
             }
             expectation.fulfill()
         })
         wait(for: [expectation], timeout: 20)
     }
}
