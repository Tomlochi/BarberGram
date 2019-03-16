//
//  Model.swift
//  BarberGram
//
//  Created by admin on 25/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation
import UIKit

class Model {
    static let instance:Model = Model()
    
    var modelFirebase = ModelFireBase();
    
    private init(){
    }
    
    func addNewUser(User:User){
        modelFirebase.createNewUser(User: User)
    }
    
    func userSignIn(email : String, password : String, callback:@escaping (Bool)->Void) {
        modelFirebase.singIn(email: email, password: password, callback: callback)
    }
    
//    func userSignIn(email : String, password : String)->Bool {
//        if (modelFirebase.singIn(email: email, password: password)){
//            return true
//        }else {
//            return false
//        }
//    }
    
    func saveImage(image:UIImage , child:String, isProfileImage:Bool,UserWithDetails:User){
        modelFirebase.uploadPhoto(image: image, child: child,IsProfileImage: isProfileImage , UserDetails :UserWithDetails)
    }
    
    func sendCommentDataToDatabase(comment: String){
        modelFirebase.sendCommentDataToDatabase(comment: comment)
    }
    
    
}
