//
//  User.swift
//  BarberGram
//
//  Created by admin on 25/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation

import Foundation
import Firebase

class User{
    var email: String?
    var username : String?
    var password: String?
    var imgUrl: String?
    
    init(){
        email = ""
        username = ""
        password = ""
        imgUrl = ""
    }
    
    init(_email:String){
        email = _email
        username = ""
        password = ""
        imgUrl = ""
    }
    
    init(_email:String, _username:String, _password:String){
        email = _email
        username = _username
        password = _password
        imgUrl = ""
    }
    
    init(_email:String, _username:String, _password:String = "", _imgUrl:String = ""){
        email = _email
        username = _username
        password = _password
        imgUrl = _imgUrl
    }
    init (json:[String:Any]){
        email = json["email"] as? String
        username = json["username"] as? String
        password = json["password"] as? String
        if json["imgUrl"] != nil {
            imgUrl = json["imgUrl"] as? String
        }else {
            imgUrl = ""
        }
    }
    
    func toJson() -> [String: Any]{
        var json = [String:Any]()
        json["email"] = email
        json["username"] = username
        json["password"] = password
        json["imgUrl"] = imgUrl
        return json
    }
    
}

extension User{
    static func transformUser(dict:[String:Any]) -> User{
        let user = User()
        user.email = dict["email"] as? String
        user.imgUrl = dict["imgUrl"] as? String
        user.username = dict["username"] as? String
        user.password = dict["password"] as? String
        return user
    }
}
