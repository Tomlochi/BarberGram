//
//  CameraViewController.swift
//  BarberGram
//
//  Created by admin on 23/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image:UIImage?
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var removeButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handelSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handlePost()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handlePost(){
        if image != nil {
        self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red:0,green:0,blue:0,alpha:1)
        }else {
        self.shareButton.isEnabled = false
             self.removeButton.isEnabled = false
              self.shareButton.backgroundColor = .lightGray
        }
    }
    
    @objc func handelSelectPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self //as!  & UINavigationControllerDelegate
            imagePicker.sourceType = UIImagePickerController.SourceType.camera;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerController.SourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    
    // UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        photo.image = image
        self.dismiss(animated: true, completion: nil)
    }
    

    
    @IBAction func shatrButton_touchUp(_ sender: Any) {
        view.endEditing(true)
//        if image != nil {
//            Model.instance.saveImage(image: image!, name: "tom"){ (url:String?) in
//                var _url = ""
//                if url != nil {
//                    _url = url!
//                }
//            }
//        }
//         let photoUrl = downloadURL.absoluteString
//         self.sendDataToDatabase(photoUrl: photoUrl)
        
        
        
        //var data = Data()
        //data = self.photo.image!.pngData()!
        let imageData = UIImageJPEGRepresentation(image!, 0.75)
        let ref = Database.database().reference()
        let photoId = ref.childByAutoId().key

        let imageRef = Storage.storage().reference(forURL: "gs://barbergram-cdafb.appspot.com/").child("posts").child(photoId!)
        _ = imageRef.putData(imageData!, metadata: nil, completion: {(metadata, error) in
            if error != nil {
                return
            }
            _ = imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {  return }// Uh-oh, an error occurred!

                let photoUrl = downloadURL.absoluteString
                self.sendDataToDatabase(photoUrl: photoUrl)
            }

        })
   }
    
    func sendDataToDatabase(photoUrl: String){
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let newPhotoId = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPhotoId!)
        newPostReference.setValue(["photoUrl": photoUrl, "caption": captionTextView.text!])
       
        self.clean()
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @IBAction func RemoveTouchUpInside(_ sender: Any) {
        self.clean()
        handlePost()
    }
    
    func clean(){
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "upload_image")
        self.image = nil
    }
    

}
