//
//  FBUserModel.swift
//  fb-viewer-swift
//
//  Created by Jonathan Yu on 7/15/14.
//  Copyright (c) 2014 Jonathan Yu. All rights reserved.
//

import Foundation

class User{
    let email: AnyObject = ""
    let name: AnyObject = ""
    let image: UIImage
    
    init(email:AnyObject, name:AnyObject, image:UIImage){
        self.image = image
        self.email = email
        self.name = name
    }
    
}