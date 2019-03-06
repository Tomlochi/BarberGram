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
        
        
        //var modelSql = ModelSql();
        var modelFirebase = ModelFireBase();
        
        private init(){
            //modelSql = ModelSql()
        }

        func addNewUser(User:User){
            modelFirebase.createNewUser(User: User)
        }
        
        func userSignIn(email : String, password : String, callback:@escaping (Bool)->Void) {
            modelFirebase.singIn(email: email, password: password, callback: callback)
        }
        
        
        func saveImage(image:UIImage, name:(String),callback:@escaping (String?)->Void){
            modelFirebase.saveImage(image: image, name: name, callback: callback)
            
        }
        
        func getImage(url:String, callback:@escaping (UIImage?)->Void){
            //modelFirebase.getImage(url: url, callback: callback)
            
            //1. try to get the image from local store
            let _url = URL(string: url)
            let localImageName = _url!.lastPathComponent
            if let image = self.getImageFromFile(name: localImageName){
                callback(image)
                print("got image from cache \(localImageName)")
            }else{
                //2. get the image from Firebase
                modelFirebase.getImage(url: url){(image:UIImage?) in
                    if (image != nil){
                        //3. save the image localy
                        self.saveImageToFile(image: image!, name: localImageName)
                    }
                    //4. return the image to the user
                    callback(image)
                    print("got image from firebase \(localImageName)")
                }
            }
        }
        
        
        /// File handling
        func saveImageToFile(image:UIImage, name:String){
            if let data = UIImageJPEGRepresentation(image, 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent(name)
                try? data.write(to: filename)
            }
        }
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in:
                .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        func getImageFromFile(name:String)->UIImage?{
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            return UIImage(contentsOfFile:filename.path)
        }

}
