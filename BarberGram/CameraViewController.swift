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
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handelSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
        
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
        if image != nil {
            Model.instance.saveImage(image: image!, name: "tom"){ (url:String?) in
                var _url = ""
                if url != nil {
                    _url = url!
                }
            }
        }
   }
    
  

}
