//
//  ViewController.swift
//  fb-viewer-swift
//
//  Created by Jonathan Yu on 7/12/14.
//  Copyright (c) 2014 Jonathan Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let fbHelper = FBHelper()
    var sources:[AlbumModel] = [AlbumModel]()
    var currentAlbumModel = AlbumModel(name: "", link: "", cover: "")
    var destController:AlbumViewerController?
    
    @IBOutlet var albumTable : UITableView
    @IBOutlet var imgProfile : UIImageView
    
    @IBAction func fetchDataAction(sender: AnyObject) {
        fbHelper.fetchAlbum()
    }
    
    @IBOutlet var btnLoginLogout: UIButton
    
    @IBAction func facebookLogoutAction(sender: AnyObject){
        self.fbHelper.logout()
        self.btnLoginLogout.titleLabel.text = "Login to Facebook"
    }
    
    @IBAction func facebookLoginAction(sender: AnyObject){
        if(self.btnLoginLogout.titleLabel.text == "Login to Facebook"){
            fbHelper.login()
        } else {
            fbHelper.logout()
        }
    }
                            
    override func viewDidLoad() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("executeHandle:"), name: "PostData", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("executeAlbum:"), name: "AlbumNotification", object: nil)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        self.currentAlbumModel = self.sources[indexPath.row]
        
        if(self.destController){
            self.destController!.albumModel = self.currentAlbumModel
            self.destController!.fbHelper = self.fbHelper
            self.destController!.executePhoto()
        }
    }
    
    func selectRowAtIndexPath(indexPath:NSIndexPath!, animated: Bool, scrollPosition: UITableViewScrollPosition){
        
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath:NSIndexPath!) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let data = self.sources[indexPath.row]
        cell.textLabel.text = data.name
        cell.detailTextLabel.text = data.link
        
        if (data.cover != ""){
            let coverPhotoURL = NSURL(string: data.cover)
            let coverPhotoData = NSData(contentsOfURL: coverPhotoURL)
            
            cell.imageView.image = UIImage(data: coverPhotoData)
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.sources.count
    }
    
    func executeAlbum(notification:NSNotification){
        let data = notification.userInfo.objectForKey("data") as [AlbumModel]
        self.sources = data
        self.albumTable.reloadData()
    }

    func executeHandle(notification:NSNotification){
        let userData = notification.object as User
        
        let name = userData.name as String
        let email = userData.email as String
        
        imgProfile.image = userData.image
        self.btnLoginLogout.titleLabel.text = "Logout"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "photoSegue"){
            let destinationController = segue.destinationViewController as AlbumViewerController
            destinationController.albumModel = self.currentAlbumModel
            self.destController = destinationController
        }
    }
    
    override func viewDidDisappear(animated: Bool){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "PostData", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "albumNotification", object: nil)
    }
}

