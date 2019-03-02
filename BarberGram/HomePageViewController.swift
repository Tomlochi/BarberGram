//
//  HomePageViewController.swift
//  BarberGram
//
//  Created by admin on 25/02/2019.
//  Copyright © 2019 Tom&Sean. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButton(_ sender: Any) {
      
        do {
       try  Auth.auth().signOut()
        }catch let logoutError{
            print (logoutError)
        }
        
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signInVc = storyBoard.instantiateInitialViewController()
        self.present(signInVc!, animated: true, completion: nil)
    }

}
