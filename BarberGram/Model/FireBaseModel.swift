//
//  FireBaseModel.swift
//  BarberGram
//
//  Created by admin on 25/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase

class ModelFireBase{
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    
    init() {
        ref = Database.database().reference()
       
}
    
    func createNewUser(User:User){
        Auth.auth().createUser(withEmail: User.email, password: User.password) { (user, error) in
            if (error != nil){
                print(error!.localizedDescription)
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let userId = Auth.auth().currentUser!.uid
            ref.self.child("users").child(userId).setValue(User.toJson())
        
          
    }
}
    
    func singIn(email:String, password:String, callback:@escaping (Bool)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                callback(false)
            }else{
                callback(true)
            }
            
        }
    }
    
//    lazy var storageRef = Storage.storage().reference(forURL:
//        "gs://barbergram-cdafb.appspot.com")
    
    
    func saveImage(image:UIImage, name:(String),
                   callback:@escaping (String?)->Void){
        let data = UIImageJPEGRepresentation(image,0.8)
        let imageRef = storageRef.child(name)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storageRef.child(name)
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        let ref = Storage.storage().reference(forURL: url)
        ref.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if error != nil {
                callback(nil)
            } else {
                let image = UIImage(data: data!)
                callback(image)
            }
        }
    }
    
    
    
    
}
