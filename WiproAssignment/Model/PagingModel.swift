//
//  PagingModel.swift
//  WiproAssignment
//
//  Created by Harsha Gunaki on 23/08/20.
//  Copyright © 2020 Harsha Gunaki. All rights reserved.
//

import Foundation

class PagingModel {
    var isFetching = false
    lazy var objectsArray = [Any]()
    var recentDownloadObjectsArray:[Any]?
    var page: Int = 1
    var pageSize: Int = 10
    var isMoreItemsPendingToDownload = true
    var maxPageSize: Int = 10 {
        didSet{
            pageSize = maxPageSize
        }
    }
    
    func resetToinitialConfig() {
        isFetching = false
        objectsArray.removeAll(keepingCapacity: false)
        recentDownloadObjectsArray?.removeAll(keepingCapacity: false)
        page = 1
        pageSize = maxPageSize
        isMoreItemsPendingToDownload = true
    }
    
}

extension PagingModel {
    func canDownload() -> Bool {
        return (isFetching == false && isMoreItemsPendingToDownload == true)
    }
    
    func processResponse(_ response : [Any]?) {
        if let array = response , array.count > 0 {
            self.recentDownloadObjectsArray = array
            self.objectsArray += array
            self.configurePaginationValuesForNextRequest()
        } else {
            self.isMoreItemsPendingToDownload = false
        }
    }
    
    private func configurePaginationValuesForNextRequest() -> Void {
        if let recent = self.recentDownloadObjectsArray , recent.count < pageSize {
            self.isMoreItemsPendingToDownload = false
        } else {
            self.isMoreItemsPendingToDownload = true
            self.page += 1
            self.maxPageSize = pageSize
        }
        
    }
}
