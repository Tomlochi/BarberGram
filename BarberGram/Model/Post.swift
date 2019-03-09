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
    
}

extension Post {
    static func transformPost(dict:[String:Any]) -> Post{
        let post = Post()
        
        post.caption = dict["caption"] as? String
        post.photoUrl = dict["photoUrl"] as? String
        post.uid  = dict["uid"] as? String
        return post
    }
}
