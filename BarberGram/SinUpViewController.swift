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
class SinUpViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 40
        profileImage.clipsToBounds = true
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
            
          
        }
        
    }
    
   
  

}
