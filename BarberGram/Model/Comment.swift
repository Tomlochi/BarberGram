//
//  Comment.swift
//  BarberGram
//
//  Created by admin on 16/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation
class Comment {
    var commentText : String?
    var uid : String?
    
}

extension Comment {
    static func transformComment(dict:[String:Any]) -> Comment{
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
