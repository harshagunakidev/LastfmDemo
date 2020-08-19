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
            case .success:
                XCTAssertNotNil(vm.searchResult)
                XCTAssertTrue(vm.searchResult!.count > 0)
                XCTAssertNotNil(vm.searchResult?[safe: 0])
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
    
    
    func testAlbumModel() {
        let wiki = Wiki(published: "1999-12-12", summary: "ABC", content: "XYZ")
        let image = Image(text: "http://www.google.com", size: Size.medium.rawValue)
        let album = Album(name: "Believe", artist: "Cher", url: "http://www.google.com", image: [image], wiki: wiki)
        XCTAssertNotNil(album)
        XCTAssertNotNil(album.wiki)
        XCTAssertEqual(album.name, "Believe")
        XCTAssertEqual(album.artist, "Cher")
        XCTAssertEqual(wiki.published, "1999-12-12")
        XCTAssertEqual(wiki.summary, "ABC")
        XCTAssertEqual(wiki.content, "XYZ")
        XCTAssertEqual(image.text, "http://www.google.com")
        XCTAssertEqual(image.size, Size.medium.rawValue)
    }
    
    func testArray(){
        let wiki = Wiki(published: "1999-12-12", summary: "ABC", content: "XYZ")
        let image = Image(text: "http://www.google.com", size: Size.medium.rawValue)
        let album = Album(name: "Believe", artist: "Cher", url: "http://www.google.com", image: [image], wiki: wiki)
        let albums = [album]
        XCTAssertNotNil(albums[safe: 0])
        XCTAssertNil(albums[safe: 1])
    }
}
