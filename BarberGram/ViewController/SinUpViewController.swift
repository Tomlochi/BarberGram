//
//  SinUpViewController.swift
//  BarberGram
//
//  Created by admin on 23/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SinUpViewController:  UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image:UIImage?
    
    
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
        singupButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        singupButton.isEnabled = false
        handleTextFiled()
    }
    
    //dismiss the keybored
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
    }
    
    
    // UIImagePickerControllerDelegate
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        profileImage.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismiss_Onclick(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextFiled.text!) { user, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let newUserWithAllDetails = User(_email: self.emailTextField.text!, _username: self.usernameTextFiled.text!, _password: self.passwordTextFiled.text!)
            
            Model.instance.saveImage(image: self.image!, child: "users",isProfileImage: true , UserWithDetails : newUserWithAllDetails)
            
            self.performSegue(withIdentifier: "singupToMenuVC", sender: nil)
        }
        
    }
}




