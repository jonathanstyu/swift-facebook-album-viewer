//
//  AlbumViewController.swift
//  fb-viewer-swift
//
//  Created by Jonathan Yu on 7/15/14.
//  Copyright (c) 2014 Jonathan Yu. All rights reserved.
//

import Foundation
class AlbumViewerController:UITableViewController{
    
    var fbHelper:FBHelper?
    var albumModel:AlbumModel = AlbumModel(name: "", link: "", cover: "")
    var sources:[UIImage] = [UIImage]()
    var singlePhotoViewController:SinglePhotoViewController?
    
    func photoExecuted(notification:NSNotification){
        let photos = notification.userInfo.valueForKey("Photos") as [UIImage]
        self.sources = photos
        self.tableView.reloadData()
    }
    
    
}