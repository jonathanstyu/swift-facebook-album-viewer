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
    
    func photoExecuted(notification:NSNotification){
        let photos = notification.userInfo.valueForKey("Photos") as [UIImage]
        self.sources = photos
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath!) -> CGFloat {
        let img = self.sources[indexPath.row]
        return img.size.height
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        cell.imageView.image = self.sources[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.sources.count
    }
    
//    override func tableView(tableView: UITAbleView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
//        let photo = self.sources[indexPath.row]
//
//    }
    
    func executePhoto(){
        self.fbHelper!.fetchPhoto(self.albumModel.link)
    }
    
    
    
}