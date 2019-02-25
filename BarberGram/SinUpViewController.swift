//
//  SinUpViewController.swift
//  BarberGram
//
//  Created by admin on 23/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SinUpViewController:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage:UIImage?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var singupButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // stayling the photo icon
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
        
        // clicking on to image icon open libary
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SinUpViewController.handelSelectProfileImageView))
       profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        handleTextFiled()
    }
    
    //prevent the user to send data with empty string in username\email\password using the sub function textFileDidChange
    func handleTextFiled (){
        usernameTextFiled.addTarget(self, action: #selector(SinUpViewController.textFileDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(SinUpViewController.textFileDidChange), for: UIControl.Event.editingChanged)
        passwordTextFiled.addTarget(self, action: #selector(SinUpViewController.textFileDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFileDidChange() {
        guard let username = usernameTextFiled.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty,
            let password = passwordTextFiled.text, !password.isEmpty else {
            singupButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                singupButton.isEnabled = false
                return
        }
        singupButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
          singupButton.isEnabled = true
    }
    
    
    
    @objc func handelSelectProfileImageView(){
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
        print("we able to got here")
        
    }

    
    // UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    var selectedImage: UIImage?
    if let editedImage = info[.editedImage] as? UIImage {
        selectedImage = editedImage
        self.profileImage.image = selectedImage!
        picker.dismiss(animated: true, completion: nil)
        print("we selcted")
        
    } else if let originalImage = info[.originalImage] as? UIImage {
        selectedImage = originalImage
        self.profileImage.image = selectedImage!
        picker.dismiss(animated: true, completion: nil)
         print("we didnt selcted")
    }
    }
    
    
    @IBAction func dismiss_Onclick(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextFiled.text!) { (user, error) in
            if (error != nil){
                print(error!.localizedDescription)
                return
            }
            var ref: DatabaseReference!
            ref = Database.database().reference()
           let userId = Auth.auth().currentUser!.uid
            ref.self.child("users").child(userId).setValue(["username": self.usernameTextFiled.text! , "email": self.emailTextField.text!,"password": self.passwordTextFiled.text!])
            // move to the home screen 
             self.performSegue(withIdentifier: "singupToMenuVC", sender: nil)
            
            
//            let storgeRef = Storage.storage().reference(forURL: "gs://barbergram-cdafb.appspot.com").child("profile_image").child(userId)
//           // let data = Date()
//            if let profileImg = self.selectedImage , let imageData = UIImage.jpegData(profileImg  , 0.8){
//                storgeRef.putData(imageData, metadata: nil, completion: { (metadata,error)  in
//                    if error != nil {
//                        return
//                    }
//                    let profileImageUrl = metadata.downloadURL()?.absusoluteString
//                })
//            }
            
            
            
            
         
        }
    }
    
    
}


