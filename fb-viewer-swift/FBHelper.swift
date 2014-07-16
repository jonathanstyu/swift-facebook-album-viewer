//
//  FBHelper.swift
//  swift-fb-album-viewer
//
//  Created by Jonathan Yu on 7/12/14.
//  Copyright (c) 2014 Jonathan Yu. All rights reserved.
//

import Foundation

class FBHelper{
    var fbsession:FBSession?;
    init(){
        self.fbsession = nil;
    }
    
    func fbAlbumRequestHandler(connection: FBRequestConnection!, result:AnyObject!, error:NSError!) {
        if let gotError = error {
            println(gotError.description)
        }
        else{
            let graphData = result.valueForKey("data") as Array
            var albums:[AlbumModel] = [AlbumModel]()
            for obj:FBGraphObject in graphData{
                let desc = obj.description
                println(desc)
                
                let name = obj.valueForKey("name") as String
                println(name)
                
                if(name == "ETC") {
                    let test = ""
                }
                
                let id = obj.valueForKey("id") as String
                var cover = ""
                
                if let existsCoverPhoto : AnyObject = obj.valueForKey("cover_photo") {
                    let coverLink = existsCoverPhoto as String
                    cover = "/\(coverLink)/photos"
                }
                
                // Print LN coverlink
                let link = "/\(id)/photos"
                
                let model = AlbumModel(name: name, link: link, cover:cover)
                albums.append(model)
            }
            
            NSNotificationCenter.defaultCenter()?.postNotificationName("albumNotification", object: nil, userInfo: ["data":albums])
        }
    }
    
    func fetchPhotosHandler(connection:FBRequestConnection!, result: AnyObject!, error: NSError!) {
        if let gotError = error{
            println(gotError.description)
        } else {
            var pictures: [UIImage] = [UIImage]()
            let graphData = result.valueForKey("data") as Array
            var albums:[AlbumModel] = [AlbumModel]()
            
            for obj:FBGraphObject in graphData{
                println(obj.description)
                let pictureURL = obj.valueForKey("picture") as String
                let url = NSURL(string: pictureURL)
                let picData = NSData(contentsOfURL: url)
                let img = UIImage(data: picData)
                
                pictures.append(img)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("photoNotification", object: nil, userInfo: ["photos":pictures])
        }
    }
    
    func fetchAlbum(){
        let request = FBRequest.requestForMe()
        
        request.graphPath = "me/Albums"
        
        request.startWithCompletionHandler(fbAlbumRequestHandler)
    }
    
    func login(){
        let activeSession = FBSession.activeSession()
        let fbSessionState = activeSession.state
        
        if(fbSessionState.value != FBSessionStateOpen.value && fbSessionState.value != FBSessionStateOpenTokenExtended.value){
            let permission = ["basic_info", "email", "user_photos", "friends_photos"]
            
            FBSession.openActiveSessionWithPublishPermissions(permission, defaultAudience: FBSessionDefaultAudienceFriends, allowLoginUI: true, completionHandler: self.fbHandler)
        }
    }
    
    func logout(){
        self.fbsession?.closeAndClearTokenInformation()
        self.fbsession?.close()
    }
    
    func fbHandler(session:FBSession!, state:FBSessionState!, error:NSError!) {
        if let gotError = error{
            println(gotError.description)
        } else{
            self.fbsession = session
            FBRequest.requestForMe()?.startWithCompletionHandler(self.fbRequestCompletionHandler)
        }
    }
    
    func fbRequestCompletionHandler(connection:FBRequestConnection!, result:AnyObject!, error:NSError!){
        if let gotError = error{
            println(gotError.description)
        } else{
            let email: AnyObject = result.valueForKey("email")
            let firstName: AnyObject = result.valueForKey("first_name")
            let UserFBID: AnyObject = result.valueForKey("id")
            
            let userImageURL = "https://graph.facebook.com/\(UserFBID)/picture?type=small"
            let url = NSURL.URLWithString(userImageURL)
            let imageData = NSData(contentsOfURL: url)
            let image = UIImage(data: imageData)
            
            println("userFBID: \(UserFBID) Email \(email) \n firstName:\(firstName) \n image: \(image)")
            
            var userModel = User(email: email, name: firstName, image: image)
            NSNotificationCenter.defaultCenter().postNotificationName("PostData", object: userModel, userInfo: nil);
        }
        
    }
}