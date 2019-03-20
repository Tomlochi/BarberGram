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
import ProgressHUD

class ModelFireBase{
    var ref: DatabaseReference!
    let storageRef = Storage.storage().reference()
    var cameraVC: CameraViewController?
    init() {
        ref = Database.database().reference()
        //    cameraVC = self as? CameraViewController
        
    }
    
    func createNewUser(User:User){
        Auth.auth().createUser(withEmail: User.email!, password: User.password!) { (user, error) in
            if (error != nil){
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    func addUserDetails(User:User){
        let userId = Auth.auth().currentUser!.uid
        self.ref.self.child("users").child(userId).setValue(User.toJson())
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
    
    
    func setUpUserInfobyComment(comment : Comment) -> User{
        var user = User()
        if let uid = comment.uid{
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dict = snapshot.value as? [String:Any]{
                    user = User.transformUser(dict: dict)
                }
            })
        }
        return(user)
    }
    
    func setUpUserInfobyPost(post : Post) -> User{
        var user = User()
        if let uid = post.uid{
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
                snapshot in
                if let dict = snapshot.value as? [String:Any]{
                    user = User.transformUser(dict: dict)
                }
            })
        }
        return(user)
    }
    
    
    func uploadPhoto(image : UIImage , child : String,IsProfileImage:Bool,UserDetails:User){
        let imageData = UIImageJPEGRepresentation(image, 0.75)
        let userId = ref.childByAutoId().key
        let imageRef = Storage.storage().reference(forURL: "gs://barbergram-cdafb.appspot.com/").child(child).child(userId!)
        _ = imageRef.putData(imageData!, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            _ = imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {  return }// Uh-oh, an error occurred!
                
                let photoUrl = downloadURL.absoluteString
                if (IsProfileImage){
                    let newUser = User(_email: UserDetails.email!, _username: UserDetails.username!, _password: UserDetails.password!, _imgUrl: photoUrl)
                    self.addUserDetails(User: newUser)
                }else{
                    self.sendImageDataToDatabase(photoUrl: photoUrl,caption: UserDetails.email!)
                }
                
            }
            
        })
        
        
    }
    
    func sendImageDataToDatabase(photoUrl: String, caption:String){
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let newPhotoId = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPhotoId!)
        let userId = Auth.auth().currentUser!.uid
        newPostReference.setValue(["uid": userId,"photoUrl": photoUrl, "caption": caption])
        
        ProgressHUD.showSuccess("Seccess")
    }
    
    func sendCommentDataToDatabase(comment: String , postId:String){
        let ref = Database.database().reference()
        let commentReference = ref.child("comments")
        let newCommentId = commentReference.childByAutoId().key
        let newCommentReference = commentReference.child(newCommentId!)
        let userId = Auth.auth().currentUser!.uid
        newCommentReference.setValue(["uid": userId,"commentText": comment])
        
        // let postId = "La61qXpVvv-vvm_Y__9"
        let postCommentRef = ref.child("post-comments").child(postId).child(newCommentId!)
        postCommentRef.setValue(true)
        
        ProgressHUD.showSuccess("Seccess")
    }
    
    func isSignIn() -> Bool {
        if Auth.auth().currentUser != nil{
            return true
        }else{
            return false
        }
    }
    
    func SignIn(email: String , password:String) -> Bool {
        var flag = Bool()
        flag = true
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                flag = false
                print(error!.localizedDescription)
            }
        }
        return (flag)
    }
    
    
}
