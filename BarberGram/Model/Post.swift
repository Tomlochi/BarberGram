//
//  Post.swift
//  BarberGram
//
//  Created by admin on 04/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation
class Post {
    var caption : String?
    var photoUrl : String?
    var uid : String?
    var id : String?
    
    init() {
        self.caption = ""
        self.photoUrl = ""
        self.uid = ""
    }
    
    
    init(uid: String, caption: String, photoUrl: String) {
        self.caption = caption
        self.photoUrl = photoUrl
        self.uid = uid
    }
    
}

extension Post {
    static func transformPost(dict:[String:Any],key:String) -> Post{
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.id = key
        post.photoUrl = dict["photoUrl"] as? String
        post.uid  = dict["uid"] as? String
        return post
    }
}
