//
//  UserSql.swift
//  BarberGram
//
//  Created by admin on 06/03/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import Foundation
import FirebaseDatabase
extension User{
    static func createTable(database: OpaquePointer?)  {
        
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USER_EMAIL TEXT PRIMARY KEY, USERNAME TEXT, IMGURL TEXT)", nil, nil, &errormsg);
        
        if(res != 0){
            
            print("error creating table");
            
            return
            
        }
        
    }
    static func getAll(database: OpaquePointer?)->[User]{
        
        var sqlite3_stmt: OpaquePointer? = nil
        
        var data = [User]()
        
        if (sqlite3_prepare_v2(database,"SELECT * from USERS;",-1,&sqlite3_stmt,nil)
            
            == SQLITE_OK){
            
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                
                let email = String(cString:sqlite3_column_text(sqlite3_stmt,0)!)
                
                let userName = String(cString:sqlite3_column_text(sqlite3_stmt,1)!)
                
                let imgUrl = String(cString:sqlite3_column_text(sqlite3_stmt,2)!)
                
                data.append(User(_email: email, _username:userName,  _imgUrl:imgUrl))
                
            }
            
        }
        
        sqlite3_finalize(sqlite3_stmt)
        
        return data
        
    }
    
    static func addNew(database: OpaquePointer?, user:User){
        
        var sqlite3_stmt: OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO USERS(USER_EMAIL, USERNAME, IMGURL) VALUES (?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let email = user.email?.cString(using: .utf8)
            
            let userName = user.username?.cString(using: .utf8)
            
            let imgUrl = user.imgUrl?.cString(using: .utf8)
            
            sqlite3_bind_text(sqlite3_stmt, 1, email,-1,nil);
            
            sqlite3_bind_text(sqlite3_stmt, 2, userName,-1,nil);
            
            sqlite3_bind_text(sqlite3_stmt, 3, imgUrl,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                
                print("new row added succefully")
                
            }
            
        }
        
        sqlite3_finalize(sqlite3_stmt)
    }
    static func get(database: OpaquePointer?, byMail:String)->User?{
        return nil;
        
    }
    
//    func getDocumentsDirectory() -> URL {
//
//        let paths = FileManager.default.urls(for: .documentDirectory, in:
//            
//            .userDomainMask)
//
//        let documentsDirectory = paths[0]
//
//        return documentsDirectory
//
//    }
 
//    static func getImageFromFile(name:String)->UIImage?{
//        let filename = self.getDocumentsDirectory().appendingPathComponent(name)
//        return UIImage(contentsOfFile:filename.path)
//
//    }
    
    
    
//    static func tryGetImageFromCache(url:String, callback:@escaping (UIImage?)->Void){
//
//        let _url = URL(string: url)
//
//        let localImageName = _url!.lastPathComponent
//
//        if let image = self.getImageFromFile(name: localImageName){
//
//            callback(image)
//
//            print("got image from cache \(localImageName)")
//
//        }
//
//    }
//
    
    
//    static func setUpUserInfo(uid : String){
//        let ProfileImage = UIImageView()
//        Database.database().reference().child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: {
//            snapshot in
//            if let dict = snapshot.value as? [String:Any]{
//                let user = User.transformUser(dict: dict)
//                if let photoUrlString = user.imgUrl{
//                    let photoUrl = URL(string: photoUrlString)
//                    tryGetImageFromCache(url: photoUrlString){ (image:UIImage?) in
//                        ProfileImage.image = image
//                    }
//                    ProfileImage.sd_setImage(with: photoUrl)
//                }
//            }
//
//        })
//    }
    
}


