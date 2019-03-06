//
//  SignInViewController.swift
//  BarberGram
//
//  Created by admin on 23/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextFiled: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.isEnabled = false
        handleTextFiled()
        
    }
    
    // if the user already logged in we will send him to homepage
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "singinToMenuVC", sender: nil)
        }
    }
    
    //dismiss the keybored 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //prevent the user to send data with empty string in username\email\password using the sub function textFileDidChange
    func handleTextFiled (){
        emailTextFiled.addTarget(self, action: #selector(SinUpViewController.textFileDidChange), for: UIControl.Event.editingChanged)
        passwordTextFiled.addTarget(self, action: #selector(SinUpViewController.textFileDidChange), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFileDidChange() {
        guard let username = emailTextFiled.text, !username.isEmpty,
            let password = passwordTextFiled.text, !password.isEmpty else {
                loginButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
                loginButton.isEnabled = false
                return
        }
        loginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        loginButton.isEnabled = true
    }

    @IBAction func signInButton_TouchUpInside(_ sender: Any) {

//        Model.instance.userSignIn(email: emailTextFiled.text!, password: passwordTextFiled.text!, callback: (Bool) -> Void)
        
        Auth.auth().signIn(withEmail: emailTextFiled.text!, password: passwordTextFiled.text!) { (user, error) in
            if error != nil {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Invalied UserName or Password", message: "Itry again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }else{
                 self.performSegue(withIdentifier: "singinToMenuVC", sender: nil)
            }

    }
    }
}
